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
    version = "42.3.0-rc.0-unstable-2026-08-25";

    src = fetchFromGitHub {
      owner = "matrix-org";
      repo = "matrix-js-sdk";
      rev = "24929be0e741be6a5d0a7226f1c682e245263b8a";
      hash = "sha256-RCGrdF6S+b0uRYFIt2YJ5FjXoyh6zvQyIHovL8SXySE=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-X03l+H+GiVsCtUzMxpRZS4B1QeUPyJ/dcj/Arbp/llM=";
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
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-call";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nbb+ob16I3rHQ8BEN041nmQItHDBoakB3SojD0tCy9w=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-/yGajAaFupPmL1/HL2qMGdpG8l0kP5t5iwb0/u2ANi8=";
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
