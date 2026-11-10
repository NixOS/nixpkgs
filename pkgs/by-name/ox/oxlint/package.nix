{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  pnpmBuildHook,
  nodejs_24,
  nodejs-slim_24,
  rustPlatform,
  cargo,
  rustc,
  cmake,
  makeBinaryWrapper,
  nix-update-script,
  rust-jemalloc-sys,
  tsgolint,
  versionCheckHook,
  darwin,
}:

let
  pnpm = pnpm_11;
in
# Build with pnpm instead of buildRustPackage because the upstream npm CLI is the
# JS-plugin-capable runtime. The standalone Rust `oxlint` binary intentionally
# runs without an external linter, which leaves `jsPlugins` configs inert.
stdenv.mkDerivation (finalAttrs: {
  pname = "oxlint";
  version = "1.91.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "oxc";
    tag = "oxlint_v${finalAttrs.version}";
    hash = "sha256-sWib0M9Myv5hHfrxOrxjRwRuphBUscgnbdtBOxfjTA8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-p61SGFyu4+CXKZn+gLbU5WEDhDqcGvF7vgqjw0Lfpkw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-en0DqsJPtDmBQbqBNDswNItCPYDntAz0S6UEgXPe+Gk=";
  };

  dontUseCmakeConfigure = true;

  pnpmWorkspaces = [ "oxlint-app" ];

  nativeBuildInputs = [
    cargo
    cmake
    makeBinaryWrapper
    nodejs_24
    pnpmConfigHook
    pnpmBuildHook
    pnpm
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [ rust-jemalloc-sys ];

  env.OXC_VERSION = finalAttrs.version;

  # Use store paths for napi's lock identity probes; Darwin's sandbox blocks
  # execution of the hardcoded host tools.
  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for cli in node_modules/.pnpm/@napi-rs+cli@*/node_modules/@napi-rs/cli/dist/cli.js; do
      substituteInPlace "$cli" \
        --replace-fail '"/bin/ps"' '"${lib.getExe' darwin.adv_cmds.ps "ps"}"' \
        --replace-fail '"/usr/sbin/ioreg"' '"${lib.getExe' darwin.IOKitTools "ioreg"}"' \
        --replace-fail '"/usr/sbin/sysctl"' '"${lib.getExe' darwin.system_cmds "sysctl"}"'
    done
  '';

  installPhase = ''
    runHook preInstall

    local -r packageRoot="$out/lib/oxlint"
    mkdir -p "$packageRoot/bin"

    cp npm/oxlint/configuration_schema.json "$packageRoot/"
    cp npm/oxlint/bin/oxlint "$packageRoot/bin/oxlint"
    cp -r apps/oxlint/dist "$packageRoot/dist"

    chmod +x "$packageRoot/bin/oxlint"

    makeBinaryWrapper "${lib.getExe nodejs-slim_24}" "$out/bin/oxlint" \
      --add-flags "$packageRoot/bin/oxlint" \
      --prefix PATH : "${lib.makeBinPath [ tsgolint ]}"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    expectFail() {
      local needle="$1"; shift
      local output
      output="$("$@" 2>&1)" && {
        printf 'expected `%s` to fail\n%s\n' "$*" "$output" >&2
        exit 1
      }
      grep -Fq "$needle" <<<"$output"
    }

    cd "$(mktemp -d)"

    cat >plugin.mjs <<'EOF'
    export default {
      meta: { name: "smoke-plugin" },
      rules: {
        "always-error": {
          create: (context) => ({
            Program(node) {
              context.report({ node, message: "plugin-smoke-ok" });
            },
          }),
        },
      },
    };
    EOF
    echo '{"jsPlugins":["./plugin.mjs"],"rules":{"smoke-plugin/always-error":"error"}}' >plugin.jsonc
    echo 'void 0;' >plugin.js
    expectFail plugin-smoke-ok "$out/bin/oxlint" -c plugin.jsonc plugin.js

    echo 'const s: string = ""; const _: string = s as string;' >type-aware.ts
    expectFail no-unnecessary-type-assertion \
      "$out/bin/oxlint" -D typescript/no-unnecessary-type-assertion --type-aware type-aware.ts

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^oxlint_v([0-9.]+)$" ];
  };

  meta = {
    description = "High-performance linter for JavaScript and TypeScript";
    homepage = "https://github.com/oxc-project/oxc";
    changelog = "https://github.com/oxc-project/oxc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "oxlint";
    inherit (nodejs-slim_24.meta) platforms;
  };
})
