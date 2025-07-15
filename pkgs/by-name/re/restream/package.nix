{
  lib,
  stdenv,
  lz4,
  ffmpeg-full,
  fetchFromGitHub,
  openssh,
  netcat,
}:

stdenv.mkDerivation rec {
  pname = "restream";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "rien";
    repo = "restream";
    rev = "v${version}";
    hash = "sha256-AXHKOfdIM3LsHF6u3M/lMhhcuPZADoEal7de3zlx7L4=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D ${src}/restream.arm.static $out/libexec/restream.arm.static
    install -D ${src}/reStream.sh $out/bin/restream

    runHook postInstall
  '';

  postInstall =
    let
      deps = [
        # `ffmpeg-full` is used here to bring in `ffplay`, which is used
        # to display the reMarkable framebuffer
        ffmpeg-full
        lz4
        openssh
        # Libressl netcat brings in `nc` which used for --uncompressed mode.
        netcat
      ];
    in
    ''
      # This `sed` command has the same effect as `wrapProgram`, except
      # without .restream-wrapped store paths appearing everywhere.
      sed -i \
        '2i export PATH=$PATH''${PATH:+':'}${lib.makeBinPath deps}' \
        "$out/bin/restream"
    '';

  meta = with lib; {
    description = "reMarkable screen sharing over SSH";
    mainProgram = "restream";
    homepage = "https://github.com/rien/reStream";
    license = licenses.mit;
    maintainers = [ maintainers.cpcloud ];
  };
}
