{
  lib,
  stdenv,
  fetchurl,
  gmp,
  mpfr,
  boost,
  flex,
  bison,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gappa";
  version = "1.8.0";

  src = fetchurl {
    url = "https://gappa.gitlabpages.inria.fr/releases/gappa-${finalAttrs.version}.tar.gz";
    hash = "sha256-dA1gOwRkW7lEo04bMldFHX0Chs8gMbd0Yl4/HhYK4qo";
  };

  strictDeps = true;

  nativeBuildInputs = [
    flex
    bison
  ];

  buildInputs = [
    gmp
    mpfr
    boost.dev
  ];

  # For darwin sandboxed builds
  postPatch = ''
    substituteInPlace remake.cpp \
      --replace 'tempnam(NULL, "rmk-")' 'tempnam(".", "rmk-")'
  '';

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
