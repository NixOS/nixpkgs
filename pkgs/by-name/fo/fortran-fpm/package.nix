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

  version = "0.11.0";

  src = fetchurl {
    url = "https://github.com/fortran-lang/fpm/releases/download/v${finalAttrs.version}/fpm-${finalAttrs.version}.F90";
    hash = "sha256-mIozF+4kSO5yB9CilBDwinnIa92sMxSyoXWAGpz1jSc=";
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
  versionCheckProgramArg = "--version";
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
