{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGL,
  libx11,
  libxt,
  imath,
  openimageio,
  python3Packages,
  pythonSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "materialx";
  version = "1.39.5";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "MaterialX";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7aY1SI5b5hVjvTtucQh6XpkwkhPZWDhsTVYLKM667/k=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.pythonRecompileBytecodeHook
  ]
  ++ lib.optional (
    pythonSupport && stdenv.buildPlatform == stdenv.hostPlatform
  ) python3Packages.pythonImportsCheckHook;

  buildInputs = [
    imath
    openimageio
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
    libx11
    libxt
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
  ];

  # create meta package providing dist-info for python3Packages.materialx
  propagatedBuildInputs = lib.optionals pythonSupport [
    (python3Packages.mkPythonMetaPackage {
      inherit (finalAttrs) pname version meta;
    })
  ];

  cmakeFlags = [
    (lib.cmakeBool "MATERIALX_BUILD_OIIO" true)
    (lib.cmakeBool "MATERIALX_BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "MATERIALX_BUILD_PYTHON" pythonSupport)
    (lib.cmakeBool "MATERIALX_BUILD_GEN_MSL" true)
  ];

  pythonImportsCheck = [ "MaterialX" ];

  postInstall = lib.optionalString pythonSupport ''
    # Make python lib properly accessible
    target_dir=$out/${python3Packages.python.sitePackages}
    mkdir -p $(dirname $target_dir)
    # required for cmake to find the bindings, when included in other projects
    ln -s $out/python $target_dir
  '';

  meta = {
    changelog = "https://github.com/AcademySoftwareFoundation/MaterialX/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Open standard for representing rich material and look-development content in computer graphics";
    homepage = "https://materialx.org";
    maintainers = [ lib.maintainers.gador ];
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
  };
})
