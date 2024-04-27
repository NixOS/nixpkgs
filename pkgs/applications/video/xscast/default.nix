{ lib, stdenv, fetchFromGitHub, makeWrapper, ffmpeg, imagemagick, dzen2, xorg }:

stdenv.mkDerivation {
  pname = "xscast-unstable";
  version = "2016-07-26";

  src = fetchFromGitHub {
    owner = "KeyboardFire";
    repo = "xscast";
    rev = "9e6fd3c28d3f5ae630619f6dbccaf1f6ca594b21";
    sha256 = "0br27bq9bpglfdpv63h827bipgvhlh10liyhmhcxls4227kagz72";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 xscast.sh $out/bin/xscast
    install -Dm644 xscast.1 $out/share/man/man1/xscast.1
    patchShebangs $out/bin

    wrapProgram "$out/bin/xscast" \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg dzen2 xorg.xwininfo xorg.xinput xorg.xmodmap imagemagick ]}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/KeyboardFire/xscast";
    license = licenses.mit;
    description = "Screencasts of windows with list of keystrokes overlayed";
    maintainers = with maintainers; [ ];
    mainProgram = "xscast";
  };
}
