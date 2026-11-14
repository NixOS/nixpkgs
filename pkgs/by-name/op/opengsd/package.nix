{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_10,
  pnpmConfigHook,
  nodejs,
  python3,
  rustPlatform,
  pkg-config,
  libxcb,
  alsa-lib,
  makeWrapper,
  autoPatchelfHook,
  versionCheckHook,
  fd,
  ripgrep,
  gh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opengsd";
  version = "1.23.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "open-gsd";
    repo = "gsd-pi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+g9+zivmz+6uSZEJtNfcgK8VvcI/ZQF/bsi/reAzwGI=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 5;
    pnpmInstallFlags = [ "--package-import-method=hardlink" ];
    hash = "sha256-d9dLyFAOGrPCpOwts2dceJ+fE4ZQthcyEb+m5Uao++s=";
  };

  nativeAddon = rustPlatform.buildRustPackage {
    pname = "opengsd-engine";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/native";
    cargoHash = "sha256-5BNwSZh6irxaT++1MGLjj4tOrB+gj8DOjEQIu9bRfqk=";
    nativeBuildInputs = [ pkg-config ];
    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];
    doCheck = false;
    installPhase = ''
      runHook preInstall
      install -Dm755 target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/libgsd_engine${stdenv.hostPlatform.extensions.sharedLibrary} \
        $out/lib/gsd_engine.node
      runHook postInstall
    '';
  };

  nativeBuildInputs = [
    pnpm_10
    pnpmConfigHook
    nodejs
    python3
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    alsa-lib
  ];

  env = {
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    NEXT_TELEMETRY_DISABLED = "1";
    npm_config_nodedir = nodejs;
    npm_config_build_from_source = "true";
  };

  buildPhase = ''
    runHook preBuild

    node scripts/link-workspace-packages.cjs
    pnpm rebuild node-pty
    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    libdir=$out/lib/opengsd
    mkdir -p $libdir $out/bin
    cp -r dist packages extensions node_modules pkg src scripts integrations package.json $libdir/
    mkdir -p $libdir/native/addon
    cp ${finalAttrs.nativeAddon}/lib/gsd_engine.node \
      $libdir/native/addon/gsd_engine.$(node -p 'process.platform + "-" + process.arch').node
    find $libdir/node_modules/@earendil-works -type l -lname "$NIX_BUILD_TOP/*" -delete
    node $libdir/scripts/link-workspace-packages.cjs

    for bin in gsd gsd-cli; do
      makeWrapper ${lib.getExe nodejs} $out/bin/$bin \
        --add-flags "$libdir/dist/bootstrap.js" \
        --prefix PATH : ${
          lib.makeBinPath [
            fd
            ripgrep
            gh
          ]
        }
    done
    makeWrapper ${lib.getExe nodejs} $out/bin/gsd-mcp-server \
      --add-flags "$libdir/packages/mcp-server/bin/gsd-mcp-server.js"

    runHook postInstall
  '';

  postInstall = ''
    # Use the source-built engine and discard binaries for other platforms.
    find $out/lib/opengsd -type d \
      \( -name '*linux*musl*' -o -path '*/@opengsd/engine-*' \) \
      -prune -exec rm -rf {} +
    koffiPlatform=$(node -p 'process.platform + "_" + process.arch')
    while IFS= read -r koffiDir; do
      find "$koffiDir" -mindepth 1 -maxdepth 1 ! -name "$koffiPlatform" \
        -exec rm -rf {} +
    done < <(find $out/lib/opengsd -type d -path '*/koffi/build/koffi')
    find $out -xtype l -delete
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  postInstallCheck = ''
    node - <<EOF
    const assert = require('node:assert/strict');
    const native = require('$out/lib/opengsd/packages/native/dist/index.js');
    assert(native.isNativeAddonLoaded(), 'OpenGSD native addon failed to load');
    assert.equal(native.visibleWidth('hello'), 5);
    EOF
  '';

  meta = {
    description = "Local-first coding agent for planning, implementing, and verifying project work";
    homepage = "https://github.com/open-gsd/gsd-pi";
    changelog = "https://github.com/open-gsd/gsd-pi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "gsd";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
