{ lib
, bash
, stdenv
, lz4
, ffmpeg-full
, fetchFromGitHub
, openssh
, netcat
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "restream";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "rien";
    repo = pname;
    rev = version;
    sha256 = "0vyj0kng8c9inv2rbw1qdr43ic15s5x8fvk9mbw0vpc6g723x99g";
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
    wrapProgram "$out/bin/restream" --suffix PATH ":" "${lib.makeBinPath [ ffmpeg-full lz4 openssh netcat ]}"
  '';

  meta = with lib; {
    description = "reMarkable screen sharing over SSH";
    homepage = "https://github.com/rien/reStream";
    license = licenses.mit;
    maintainers = [ maintainers.cpcloud ];
  };
}
