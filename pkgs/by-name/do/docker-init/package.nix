{
  stdenv,
  fetchurl,
  zstd,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "docker-init";
  version = "v1.3.0";
  tag = "157355";

  src = fetchurl {
    url = "https://desktop.docker.com/linux/main/amd64/${finalAttrs.tag}/docker-desktop-x86_64.pkg.tar.zst";
    hash = "sha256-ysZorPBmoUvTJFFKDbZgQxPamONJKcXezmMrpZSVpwY=";
  };

  nativeBuildInputs = [
    zstd
  ];

  unpackPhase = ''
    runHook preUnpack
    tar --zstd -xvf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,libexec/docker/cli-plugins}

    cp usr/lib/docker/cli-plugins/docker-init $out/libexec/docker/cli-plugins
    ln -s $out/libexec/docker/cli-plugins/docker-init $out/bin/docker-init
    runHook postInstall
  '';

  meta = {
    description = "Creates Docker-related starter files for your project";
    homepage = "https://docs.docker.com/reference/cli/docker/init";
    downloadPage = "https://docs.docker.com/desktop/release-notes/#4320";
    mainProgram = "docker-init";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    badPlatforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ BastianAsmussen ];
  };
})
