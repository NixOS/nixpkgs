{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
  makeBinaryWrapper,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neon-cli";
  version = "9.10.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "neondatabase";
    repo = "neon-pkgs";
    tag = "neon@${finalAttrs.version}";
    hash = "sha256-jLZiaJA65tiG8G/Ep3992ZEc+G5M0X2Ng2FVdPwaeZ4=";
  };

  pnpmWorkspaces = [ "neon..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    fetcherVersion = 5;
    hash = "sha256-DG1to9yhkLqjIZdxqQOm1nbnTzWxSYriQ/VPUO5WBvQ=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
    makeBinaryWrapper
  ];

  # tsdown keeps glob entries in tinyglobby's unstable order, which reorders
  # imports between builds. https://github.com/rolldown/tsdown/issues/1134
  preBuild = ''
    substituteInPlace node_modules/.pnpm/tsdown@*/node_modules/tsdown/dist/src-*.mjs \
      --replace-fail "})).map((file) => path.resolve(cwd, file));" \
        "})).sort().map((file) => path.resolve(cwd, file));"
  '';

  buildPhase = ''
    runHook preBuild
    pnpm --filter "neon..." build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    pnpm config set --location=project injectWorkspacePackages true
    pnpm --filter neon --prod deploy $out/lib/neon
    # Type declarations of the workspace packages list union members in a
    # different order on each build, and the CLI never reads them at runtime.
    find $out/lib/neon/node_modules/.pnpm/@neon+*@file+* \
      \( -name '*.d.ts' -o -name '*.d.ts.map' \) -delete
    makeWrapper ${lib.getExe nodejs} $out/bin/neon \
      --add-flags $out/lib/neon/dist/cli.js
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^neon@(.*)$" ];
  };

  meta = {
    description = "CLI tool for Neon, the cloud backend primitives built around Lakebase Postgres";
    homepage = "https://github.com/neondatabase/neon-pkgs";
    changelog = "https://github.com/neondatabase/neon-pkgs/blob/neon@${finalAttrs.version}/packages/cli/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "neon";
    # Built from source; npm supplies prebuilt esbuild, rollup and keyring binaries.
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = [ lib.maintainers.randoneering ];
    platforms = lib.platforms.unix;
  };
})
