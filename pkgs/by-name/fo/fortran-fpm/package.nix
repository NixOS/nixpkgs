{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fortran-fpm";

  version = "0.14.0";

  src = fetchurl {
    url = "https://github.com/fortran-lang/fpm/releases/download/v${finalAttrs.version}/fpm-${finalAttrs.version}.F90";
    hash = "sha256-piC7tty29wS622PdDTuUT9Q3s6ji5OOs1UrCPqBr2Bs=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ gfortran ];

  buildPath = "build/bootstrap";

  buildPhase = ''
    runHook preBuild

    mkdir -p ${finalAttrs.buildPath}
    gfortran -J ${finalAttrs.buildPath} -o ${finalAttrs.buildPath}/fortran-fpm $src

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ${finalAttrs.buildPath}/fortran-fpm $out/bin

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fortran Package Manager (fpm)";
    homepage = "https://fpm.fortran-lang.org";
    maintainers = [ lib.maintainers.proofconstruction ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "fortran-fpm";
  };
})
