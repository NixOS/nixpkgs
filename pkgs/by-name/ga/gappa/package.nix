{
  lib,
  stdenv,
  fetchurl,
  gmp,
  mpfr,
  boost,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gappa";
  version = "1.7.0";

  src = fetchurl {
    url = "https://gappa.gitlabpages.inria.fr/releases/gappa-${finalAttrs.version}.tar.gz";
    hash = "sha256-NAEaQcS5NsbfH6MoL+THTJYZyeAJ4VQyp1kiFXeV0cU=";
  };

  strictDeps = true;

  buildInputs = [
    gmp
    mpfr
    boost.dev
  ];

  buildPhase = ''
    runHook preBuild

    ./remake

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./remake install

    runHook postInstall
  '';

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gappa.gitlabpages.inria.fr/";
    description = "Verifying and formally proving properties on numerical programs dealing with floating-point or fixed-point arithmetic";
    mainProgram = "gappa";
    license = with lib.licenses; [
      cecill21
      gpl3
    ];
    maintainers = with lib.maintainers; [ vbgl ];
    platforms = lib.platforms.all;
  };
})
