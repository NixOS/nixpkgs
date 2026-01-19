{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "difit";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "yoshiko-pg";
    repo = "difit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kXawH0S89TWjtExoFobeNZ6VbP/ZX/bUP+kB290CQzQ=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 1;
    hash = "sha256-x0RyM2MmzJ9cpFh8P5P7gNwIM0MZSAGTx4sjurVDp1Y=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_10
  ];

  buildInputs = [
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
        runHook preInstall

        mkdir -p $out/{bin,lib/difit}
        cp -r {dist,node_modules,package.json} $out/lib/difit

        # Create wrapper script
        cat > $out/bin/difit <<EOF
    #!/bin/sh
    exec ${nodejs}/bin/node $out/lib/difit/dist/cli/index.js "\$@"
    EOF
        chmod +x $out/bin/difit

        runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight CLI tool for viewing and reviewing Git commit diffs in a GitHub-like interface";
    homepage = "https://github.com/yoshiko-pg/difit";
    changelog = "https://github.com/yoshiko-pg/difit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chansuke ];
    mainProgram = "difit";
    platforms = nodejs.meta.platforms;
  };
})
