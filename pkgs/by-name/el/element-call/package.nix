{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_11,
  pnpmConfigHook,
  fetchPnpmDeps,
  nodejs,
  runCommand,
}:

let
  pnpm = pnpm_11;

  # Separately build matrix-js-sdk, as upstream expects to 'pnpm i && pnpm build' in the dependency's directory
  # Keep this in sync with upstream locked version (likely a stable release, but not always latest)
  matrix-js-sdk = stdenv.mkDerivation (finalAttrs: {
    pname = "matrix-js-sdk";
    version = "44.0.0-unstable-2026-10-14";

    src = fetchFromGitHub {
      owner = "matrix-org";
      repo = "matrix-js-sdk";
      rev = "3f05dc4d104a3dfc753c5e3549a18c74fab4b076";
      hash = "sha256-r2NcIeG+/6mQUXWWiMBZya6XiBfzu5RaXvkCy8mh/8U=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 5;
      hash = "sha256-1KyZI4Eif4fLtkMkf67dj/qavMIUMRXMz3GACn99I3g=";
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
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-call";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7qqsTpJBIH/M8Prja0Q+CjkZ5tenyVPS27Y+fYKDIe0=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-AGsaLrtGxr23fLsRwKIPf90R5oZDx6Y0EiJOo02R8Ls=";
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
    description = "Matrix client for group calls on the web";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      bartoostveen
      kilimnik
    ];
  };
})
