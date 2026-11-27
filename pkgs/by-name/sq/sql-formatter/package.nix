{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nodejs,
  makeBinaryWrapper,
  nix-update-script,
}:
let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sql-formatter";
  version = "15.10.0";

  src = fetchFromGitHub {
    owner = "sql-formatter-org";
    repo = "sql-formatter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QNTA0UfbE7aVoDXuFj5RheaLkbjjWc923OXjO/JR4vU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      src
      version
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-XVgAOdV3F3j6V1f2gxGFxMUALdEvClmFDbN6FYP0kiw=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    CI=true pnpm prune --prod --ignore-scripts
    find node_modules -xtype l -delete
    rm -f node_modules/.modules.yaml node_modules/.pnpm-workspace-state-v1.json

    mkdir -p $out/lib/node_modules/sql-formatter
    cp -r package.json bin dist node_modules $out/lib/node_modules/sql-formatter/

    makeWrapper ${lib.getExe nodejs} $out/bin/sql-formatter \
      --add-flags $out/lib/node_modules/sql-formatter/bin/sql-formatter-cli.cjs

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Whitespace formatter for different query languages";
    homepage = "https://sql-formatter-org.github.io/sql-formatter";
    license = lib.licenses.mit;
    mainProgram = "sql-formatter";
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
