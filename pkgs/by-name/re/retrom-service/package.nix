{
  lib,
  pkg-config,
  rustPlatform,
  pnpmConfigHook,
  pnpm_10, # used in upstream build toolchain
  nodejs_24, # used in upstream build toolchain
  faketty, # nx requires a TTY, see https://github.com/nrwl/nx/issues/22445
  perl,
  protobuf_29,
  openssl,
  makeWrapper,

  retrom,
  withEmbeddedDb ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "retrom-service";

  # client and service designed for matching version
  inherit (retrom)
    version
    src
    pnpmDeps
    cargoDeps
    ;

  __structuredAttrs = true;

  buildAndTestSubdir = "packages/service";

  cargoBuildFeatures = lib.optional withEmbeddedDb "embedded_db";

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

  preBuild = ''
    export CI=true
    export NX_NO_CLOUD=true
    export NX_DAEMON=false

    export VITE_BASE_URL=/web

    # See https://github.com/nrwl/nx/issues/22445
    faketty pnpm nx build retrom-client-web

    # Work around for https://github.com/pnpm/pnpm/issues/5315
    mkdir -p web

    cp -r packages/client-web/dist web

    cp pnpm-workspace.yaml web
    cp pnpm-lock.yaml web
    cp package.json web
    cp README.md web
    cp packages/client-web/vite.config.ts web

    pushd web
    pnpm install --prod --offline --frozen-lockfile

    rm -f pnpm-workspace.yaml pnpm-lock.yaml
    popd
  '';

  postInstall = ''
    mkdir -p $out/share
    cp -r web $out/share/retrom
  '';

  postFixup = ''
    wrapProgram $out/bin/retrom-service --set RETROM_WEB_DIR $out/share/retrom
  '';

  meta = with lib; {
    description = "Server component of the Retrom game library management service";
    homepage = "https://github.com/JMBeresford/retrom";
    changelog = "https://github.com/JMBeresford/retrom/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      concurac
    ];
    # Upstream supports macOS and Windows but only Linux is tested in nixpkgs
    platforms = platforms.linux;
    mainProgram = "retrom-service";
  };
})
