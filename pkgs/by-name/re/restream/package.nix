{
  lib,
  stdenv,
  lz4,
  ffmpeg-full,
  fetchFromGitHub,
  openssh,
  netcat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "restream";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "rien";
    repo = "restream";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rJYdmBQrDH/oURXVO8WWTxgvibcpNC8yxno6pZPl6No=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D ${finalAttrs.src}/restream.arm.static $out/libexec/restream.arm.static
    install -D ${finalAttrs.src}/reStream.sh $out/bin/restream

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

  meta = {
    description = "reMarkable screen sharing over SSH";
    mainProgram = "restream";
    homepage = "https://github.com/rien/reStream";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.cpcloud ];
  };
})
