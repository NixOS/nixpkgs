{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  nodejs,
  runCommand,
}:

let
  pnpm = pnpm_10;

  # Separately build matrix-js-sdk, as upstream expects to 'pnpm i && pnpm build' in the dependency's directory
  # Keep this in sync with upstream locked version (likely a stable release, but not always latest)
  matrix-js-sdk = stdenv.mkDerivation (finalAttrs: {
    pname = "matrix-js-sdk";
    version = "41.8.0-rc.0";

    src = fetchFromGitHub {
      owner = "matrix-org";
      repo = "matrix-js-sdk";
      tag = "v${finalAttrs.version}";
      hash = "sha256-1e6nWeHNAhVynxv2R7GY5NRCBN0BriRjA3zLK0D5O9g=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-Me76t/wl4HtmbQ+FzUNLEpOM6aYbzTl68tuDSEh+Hq4=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    buildPhase = ''
      runHook preBuild
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r src $out/
      cp -r lib $out/
      cp package.json $out/

      runHook postInstall
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "element-call";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-call";
    tag = "v${finalAttrs.version}";
    hash = "sha256-paUcZhjcLbJOpQOR8gRpGe0LzSaKtWsTzE1svzQaVZY=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-JOpKxtElmNKepx3W+1LIolcrYrevsCEq7+Aoh0kwZEw=";
  };

  inherit matrix-js-sdk;

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  buildPhase = ''
    runHook preBuild
    # Instead of making an override, invalidating the pnpm lock, just add the built files in lib right before invoking pnpm build
    cp -r ${finalAttrs.matrix-js-sdk}/* node_modules/matrix-js-sdk/
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r dist/* $out

    runHook postInstall
  '';

  passthru = {
    tests.build = runCommand "${finalAttrs.pname}-test" { } ''
      test -f ${finalAttrs.finalPackage}/index.html
      test -d ${finalAttrs.finalPackage}/assets
      touch $out
    '';
    inherit (finalAttrs) matrix-js-sdk;
  };

  meta = {
    changelog = "https://github.com/element-hq/element-call/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/element-hq/element-call";
    description = "Group calls powered by Matrix";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      bartoostveen
      kilimnik
    ];
  };
})
