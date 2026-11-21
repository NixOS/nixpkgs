{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  cargo,
  cmake,
  makeBinaryWrapper,
  nodejs_24,
  nodejs-slim_24,
  pnpm_12,
  pnpmBuildHook,
  pnpmConfigHook,
  rustPlatform,
  rustc,
  versionCheckHook,
  nix-update-script,
  darwin,
}:

let
  pnpm = pnpm_12;
in
# Build the upstream npm CLI to retain Prettier support alongside the Rust formatter.
stdenv.mkDerivation (finalAttrs: {
  pname = "oxfmt";
  version = "0.79.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "oxc";
    tag = "oxfmt_v${finalAttrs.version}";
    hash = "sha256-yhA51CwgFXFUaxIbupoDc/7oyMF46BPoJS9pJco+Sac=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-KX/eU+QgIUs8dtNnbWAjOGRGXWWRkzYb5Zppwohgwmc=";
  };

  pnpmWorkspaces = [ "oxfmt-app" ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-qk4FaEzMvmCDKuiNWWa9+XiexiZtSHZ+ya4rzKF2gKA=";
  };

  nativeBuildInputs = [
    cargo
    cmake
    makeBinaryWrapper
    nodejs_24
    pnpm
    pnpmBuildHook
    pnpmConfigHook
    rustPlatform.cargoSetupHook
    rustc
  ];

  # libmimalloc-sys2 invokes CMake from its Cargo build script.
  dontUseCmakeConfigure = true;

  # pnpmConfigHook has already installed the locked dependencies offline.
  env.pnpm_config_verify_deps_before_run = "false";

  preBuild = ''
    # Use the Nix shell so pnpm's workspace launchers find sandbox tools on PATH.
    patchShebangs --build apps/oxfmt/node_modules/.bin
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Use store paths for napi's lock identity probes in the Darwin sandbox.
    substituteInPlace apps/oxfmt/node_modules/@napi-rs/cli/dist/cli.js \
      --replace-fail '"/bin/ps"' '"${lib.getExe' darwin.adv_cmds.ps "ps"}"' \
      --replace-fail '"/usr/sbin/ioreg"' '"${lib.getExe' darwin.IOKitTools "ioreg"}"' \
      --replace-fail '"/usr/sbin/sysctl"' '"${lib.getExe' darwin.system_cmds "sysctl"}"'
  '';

  installPhase = ''
    runHook preInstall

    local -r packageRoot="$out/lib/oxfmt"
    mkdir -p "$packageRoot/bin" "$packageRoot/node_modules"

    cp npm/oxfmt/{configuration_schema.json,package.json} "$packageRoot/"
    install -Dm755 npm/oxfmt/bin/oxfmt "$packageRoot/bin/oxfmt"
    cp -r apps/oxfmt/dist "$packageRoot/dist"
    # Upstream bundles the other runtime dependencies into dist.
    cp -rL apps/oxfmt/node_modules/tinypool "$packageRoot/node_modules/"

    makeBinaryWrapper "${lib.getExe nodejs-slim_24}" "$out/bin/oxfmt" \
      --add-flags "$packageRoot/bin/oxfmt"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  installCheckPhase = ''
    runHook preInstallCheck

    cd "$(mktemp -d)"
    printf 'const x=1\n' | "$out/bin/oxfmt" --stdin-filepath test.js > actual.js
    diff -u <(printf 'const x = 1;\n') actual.js

    # MDX exercises the bundled Prettier formatter and its worker.
    printf '#   Hello\n' | "$out/bin/oxfmt" --stdin-filepath test.mdx > actual.mdx
    diff -u <(printf '# Hello\n') actual.mdx

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^oxfmt_v([0-9.]+)$" ];
  };

  meta = {
    description = "High-performance formatter for the JavaScript ecosystem";
    homepage = "https://oxc.rs/docs/guide/usage/formatter";
    downloadPage = "https://github.com/oxc-project/oxc";
    changelog = "https://github.com/oxc-project/oxc/blob/${finalAttrs.src.tag}/apps/oxfmt/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      iamanaws
      natsukium
    ];
    mainProgram = "oxfmt";
    inherit (nodejs-slim_24.meta) platforms;
  };
})
