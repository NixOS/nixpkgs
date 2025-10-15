{
  lib,
  stdenv,
  fetchurl,
  gmp,
  mpfr,
  boost,
  version ? "1.6.1",
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "gappa";
  inherit version;

  src = fetchurl {
    url = "https://gappa.gitlabpages.inria.fr/releases/gappa-${version}.tar.gz";
    hash = "sha256-1ux5ImKR8edXyvL21w3jY2o4/fATEjO2SMzS8B0o8Ok=";
  };

  buildInputs = [
    gmp
    mpfr
    boost.dev
  ];

  buildPhase = "./remake";
  installPhase = "./remake install";

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
}
