{ lib
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

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D ${src}/restream.arm.static $out/libexec/restream.arm.static
    install -D ${src}/reStream.sh $out/bin/restream

    runHook postInstall
  '';

  postInstall = let
    deps = [
      # `ffmpeg-full` is used here to bring in `ffplay`, which is used
      # to display the reMarkable framebuffer
      ffmpeg-full
      lz4
      openssh
      # Libressl netcat brings in `nc` which used for --uncompressed mode.
      netcat
    ];
  in ''
    # This `sed` command has the same effect as `wrapProgram`, except
    # without .restream-wrapped store paths appearing everywhere.
    sed -i \
      '2i export PATH=$PATH''${PATH:+':'}${lib.makeBinPath deps}' \
      "$out/bin/restream"
  '';

  meta = with lib; {
    description = "reMarkable screen sharing over SSH";
    homepage = "https://github.com/rien/reStream";
    license = licenses.mit;
    maintainers = [ maintainers.cpcloud ];
  };
}
