{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "srt-to-vtt-cl";
  version = "unstable-2019-01-03";

  src = fetchFromGitHub {
    owner = "nwoltman";
    repo = pname;
    rev = "ce3d0776906eb847c129d99a85077b5082f74724";
    sha256 = "0qxysj08gjr6npyvg148llmwmjl2n9cyqjllfnf3gxb841dy370n";
  };

  patches = [
    ./fix-validation.patch
    ./simplify-macOS-builds.patch
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/srt-vtt $out/bin
  '';

  meta = with lib; {
    description = "Convert SRT files to VTT";
    license = licenses.mit;
    maintainers = with maintainers; [ ericdallo ];
    homepage = "https://github.com/nwoltman/srt-to-vtt-cl";
    platforms = platforms.unix;
    mainProgram = "srt-vtt";
  };
}
