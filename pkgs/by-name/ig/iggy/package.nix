{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  hwloc,
  importNpmLock,
  installShellFiles,
  nixosTests,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (
  finalAttrs:
  let
    webUI = buildNpmPackage {
      pname = "iggy-web-ui";
      version = finalAttrs.version;

      src = "${finalAttrs.src}/web";

      npmDeps = importNpmLock { npmRoot = "${finalAttrs.src}/web"; };
      npmConfigHook = importNpmLock.npmConfigHook;

      buildPhase = ''
        npm run build:static
      '';

      installPhase = ''
        cp -r build/static $out
      '';
    };
  in
  {
    pname = "iggy";
    version = "0.8.0";
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "apache";
      repo = "iggy";
      tag = "server-${finalAttrs.version}";
      hash = "sha256-WeqS6XVnDiTJlSs+AdOmBrQIZh5reW9YWbzm0sk34o0=";
    };

    cargoHash = "sha256-xkZ6eOtIzPdPgVDxFyPmO2KKRTaJrFRf+CALfEClb+U=";

    cargoBuildFlags = [
      "--bin=iggy"
      "--bin=iggy-mcp"
      "--bin=iggy-server"
    ];

    # Tests require librusty v8.
    doCheck = false;

    nativeBuildInputs = [
      installShellFiles
      pkg-config
    ];

    buildInputs = [ hwloc ];

    preBuild = ''
      mkdir -p web/build
      cp -rL --no-preserve=mode ${webUI} web/build/static
    '';

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd iggy \
        --bash <($out/bin/iggy --generate bash) \
        --zsh <($out/bin/iggy --generate zsh) \
        --fish <($out/bin/iggy --generate fish)
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [ versionCheckHook ];

    passthru = {
      tests = { inherit (nixosTests) iggy; };
      updateScript = nix-update-script {
        extraArgs = [
          "--version-regex"
          "^server-(.*)"
        ];
      };
    };

    meta = {
      description = "High-performance, persistent message streaming platform";
      homepage = "https://iggy.apache.org";
      changelog = "https://github.com/apache/iggy/releases/tag/server-${finalAttrs.version}";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ jpds ];
      platforms = lib.platforms.linux;
      mainProgram = "iggy-server";
    };
  }
)
