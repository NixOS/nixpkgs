{
  fetchFromGitHub,
  gmp,
  lib,
  ocl-icd,
  opencl-headers,
  stdenv,
  boinc,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "genefer";
  version = "25.12.0";

  src = fetchFromGitHub {
    owner = "galloty";
    repo = "genefer22";
    rev = "37ea9f8f531ee625d10408e1d2a4ec4dcf270438";
    hash = "sha256-dyrg9Yf1Ko8vfV4oH7yVTFfLkCHWeJlm2xjEqjiwHBg=";
  };

  enableParallelBuilding = true;
  buildInputs = [
    gmp
    ocl-icd
    opencl-headers
    boinc
  ];

  # remove the static flags
  # fix BOINC path
  postPatch = ''
    sed -i 's/-static-libgcc//g' genefer/Makefile_linux*
    sed -i 's/-static-libstdc++//g' genefer/Makefile_linux*
    sed -i 's/-static//g' genefer/Makefile_linux*

    substituteInPlace genefer/Makefile_linux* \
        --replace-fail '$(BOINC_DIR)/api' '${boinc}/include/boinc' \
        --replace-fail '$(BOINC_DIR)/lib' '${boinc}/include/boinc'
  '';

  makefile = if stdenv.hostPlatform.isAarch64 then "Makefile_linuxARM64" else "Makefile_linux64";

  makeFlags = [
    "-C genefer"
    "-f ${finalAttrs.makefile}"
  ];

  installPhase =
    let
      platformSuffix = if stdenv.hostPlatform.isAarch64 then "_arm64" else "";
    in
    ''
      runHook preInstall

      install -Dm755 bin/genefer${platformSuffix} $out/bin/genefer22
      install -Dm755 bin/geneferg${platformSuffix} $out/bin/genefer22-gpu

      mkdir -p $out/share/genefer22
      cp -r $src/ocl $out/share/genefer22/

      runHook postInstall
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Generalized Fermat Prime search program";
    longDescription = ''
      genefer is an OpenMP® application on CPU and an OpenCL™ application on GPU.
      It performs a fast probable primality test for numbers of the form b^2n + 1 with the Fermat test.
    '';
    homepage = "https://github.com/galloty/genefer22";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.mit;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "genefer22";
  };
})
