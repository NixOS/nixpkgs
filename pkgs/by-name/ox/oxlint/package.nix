{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  pnpmBuildHook,
  nodejs_24,
  nodejs-slim,
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
  version = "1.78.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "oxc";
    tag = "oxlint_v${finalAttrs.version}";
    hash = "sha256-55IzeYx7Bfs40gvfyvbog+QKab5DoXNI1ydc/mcvQDQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-mVk2thsSITIQ6vCQkxBlBvQpPRS0jpWoN+wZ3WJLoJw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-buM8gRuxi9rrcUVYXHEOnjWpbD4godiNQHAXAUTP7C0=";
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

  # @napi-rs/cli >= 3.8 reads the process start time via `/bin/ps` while
  # acquiring its filesystem reconciliation lock. The Darwin build sandbox
  # denies that exec; Node raises it as a synchronous `spawn EPERM` from
  # execFile, which escapes napi's callback-based error handling. Point the
  # lookup at a store `ps` so the sandbox allows it. The result is only used
  # to detect stale lock files.
  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for cli in node_modules/.pnpm/@napi-rs+cli@*/node_modules/@napi-rs/cli/dist/cli.js; do
      substituteInPlace "$cli" \
        --replace-fail '"/bin/ps"' '"${darwin.adv_cmds}/bin/ps"'
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

    makeBinaryWrapper "${lib.getExe nodejs-slim}" "$out/bin/oxlint" \
      --add-flags "$packageRoot/bin/oxlint" \
      --prefix PATH : "${lib.makeBinPath [ tsgolint ]}"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    pluginTestDir="$(mktemp -d)"
    cat > "$pluginTestDir/plugin.mjs" <<'EOF'
    const plugin = {
      meta: { name: "smoke-plugin" },
      rules: {
        "always-error": {
          create(context) {
            return {
              Program(node) {
                context.report({ node, message: "plugin-smoke-ok" });
              },
            };
          },
        },
      },
    };
    export default plugin;
    EOF
    cat > "$pluginTestDir/.oxlintrc.jsonc" <<'EOF'
    {
      "jsPlugins": ["./plugin.mjs"],
      "rules": {
        "smoke-plugin/always-error": "error"
      }
    }
    EOF
    printf 'const value = 1;\n' > "$pluginTestDir/input.js"

    (
      cd "$pluginTestDir"
      set +e
      pluginOutput="$($out/bin/oxlint input.js 2>&1)"
      pluginStatus=$?
      set -e
      test "$pluginStatus" -ne 0
      printf '%s\n' "$pluginOutput" | grep -F "plugin-smoke-ok" > /dev/null
    )

    typeAwareTestDir="$(mktemp -d)"
    cat > "$typeAwareTestDir/.oxlintrc.jsonc" <<'EOF'
    {
      "rules": {
        "typescript/no-unnecessary-type-assertion": "error"
      }
    }
    EOF
    cat > "$typeAwareTestDir/tsconfig.json" <<'EOF'
    {
      "compilerOptions": {
        "target": "es2024",
        "lib": ["ES2024", "DOM"],
        "module": "es2022",
        "strict": true,
        "skipLibCheck": true
      }
    }
    EOF
    cat > "$typeAwareTestDir/input.ts" <<'EOF'
    const str: string = "hello";
    const redundant = str as string;

    export {};
    EOF

    (
      cd "$typeAwareTestDir"
      set +e
      typeAwareOutput="$($out/bin/oxlint --type-aware input.ts 2>&1)"
      typeAwareStatus=$?
      set -e
      test "$typeAwareStatus" -ne 0
      printf '%s\n' "$typeAwareOutput" | grep -F "no-unnecessary-type-assertion" > /dev/null
    )

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^oxlint_v([0-9.]+)$" ];
  };

  meta = {
    description = "Collection of JavaScript tools written in Rust";
    homepage = "https://github.com/oxc-project/oxc";
    changelog = "https://github.com/oxc-project/oxc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "oxlint";
    inherit (nodejs-slim.meta) platforms;
  };
})
