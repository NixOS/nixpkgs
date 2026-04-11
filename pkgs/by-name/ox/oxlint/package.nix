{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
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
}:

# Build with pnpm instead of buildRustPackage because the upstream npm CLI is the
# JS-plugin-capable runtime. The standalone Rust `oxlint` binary intentionally
# runs without an external linter, which leaves `jsPlugins` configs inert.
stdenv.mkDerivation (finalAttrs: {
  pname = "oxlint";
  version = "1.58.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "oxc";
    tag = "oxlint_v${finalAttrs.version}";
    hash = "sha256-FqKqLO31ej9NgBdcCjzVkgjlfMHV6RZMcHbdBVVwhHs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-OpMGS5+pTPZvfY2EMxQMTWrCHhnxUQb9kQC/pLvrZSY=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-cYlY8UHd9yWWJkktycfhbvg/7N2rY9h/jYA+QQ20rK0=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cargo
    cmake
    makeBinaryWrapper
    nodejs_24
    pnpmConfigHook
    pnpm_10
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [ rust-jemalloc-sys ];

  env.OXC_VERSION = finalAttrs.version;

  buildPhase = ''
    runHook preBuild

    pnpm --workspace-concurrency=1 --filter oxlint-app run build

    runHook postBuild
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
