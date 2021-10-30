{ lib
, bash
, stdenv
, lz4
, ffmpeg-full
, fetchFromGitHub
, openssh
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "restream";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "rien";
    repo = pname;
    rev = version;
    sha256 = "18z17chl7r5dg12xmr3f9gbgv97nslm8nijigd03iysaj6dhymp3";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D ${src}/restream.arm.static $out/libexec/restream.arm.static
    install -D ${src}/reStream.sh $out/bin/restream

    runHook postInstall
  '';

  postInstall = ''
    # `ffmpeg-full` is used here to bring in `ffplay`, which is used to display
    # the reMarkable framebuffer
    wrapProgram "$out/bin/restream" --suffix PATH ":" "${lib.makeBinPath [ ffmpeg-full lz4 openssh ]}"
  '';

  meta = with lib; {
    description = "reMarkable screen sharing over SSH";
    homepage = "https://github.com/rien/reStream";
    license = licenses.mit;
    maintainers = [ maintainers.cpcloud ];
  };
}
