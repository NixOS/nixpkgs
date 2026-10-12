{
  lib,
  pkg-config,
  rustPlatform,
  pnpmConfigHook,
  pnpm_10,
  nodejs_24,
  faketty,
  perl,
  protobuf_29,
  openssl,
  makeWrapper,

  retrom,
  withEmbeddedDb ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "retrom-service";

  __structuredAttrs = true;
  strictDeps = true;

  # client and service designed for matching version
  inherit (retrom)
    version
    src
    pnpmDeps
    cargoDeps
    ;

  cargoBuildFeatures = lib.optional withEmbeddedDb "embedded_db";

  buildAndTestSubdir = "packages/service";

  nativeBuildInputs = [
    pkg-config
    pnpmConfigHook
    pnpm_10
    nodejs_24
    faketty
    perl
    protobuf_29
    makeWrapper
  ];

  buildInputs = [
    openssl
  ];

  env = {
    CI = "true";
    NX_NO_CLOUD = "true";
    NX_DAEMON = "false";
    OPENSSL_NO_VENDOR = "1";
    VITE_BASE_URL = "/web";
  };

  preBuild = ''
    # See https://github.com/nrwl/nx/issues/22445
    faketty pnpm nx build retrom-client-web
  '';

  postInstall = ''
    mkdir -p $out/share/retrom/
    cp -r packages/client-web/dist $out/share/retrom/
  '';

  postFixup = ''
    wrapProgram $out/bin/retrom-service --set RETROM_WEB_DIR $out/share/retrom
  '';

  meta = {
    description = "Server component of the Retrom game library management service";
    homepage = "https://github.com/JMBeresford/retrom";
    changelog = "https://github.com/JMBeresford/retrom/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      concurac
    ];
    # Upstream supports macOS and Windows but only Linux has so far been tested
    platforms = lib.platforms.linux;
    mainProgram = "retrom-service";
  };
})
