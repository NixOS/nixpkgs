{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  enablePython ? true,
  addBinToPathHook,
  python3Packages,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gemmi";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "project-gemmi";
    repo = "gemmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XOu//yY5CnnzjvGu7IIC5GvecYsnZQV3Y2wvGVTwWzU=";
  };

  nativeBuildInputs =
    [ cmake ]
    ++ lib.optionals enablePython (
      with python3Packages;
      [
        nanobind
        python
        pythonImportsCheckHook
      ]
    );

  buildInputs = [ zlib ];

  cmakeFlags = [
    (lib.cmakeBool "USE_PYTHON" enablePython)
    (lib.cmakeFeature "PYTHON_INSTALL_DIR" "${python3Packages.python.sitePackages}")
  ];

  doCheck = true;

  pythonImportsCheck = [ "gemmi" ];

  doInstallCheck = enablePython;

  nativeInstallCheckInputs =
    with python3Packages;
    [
      # biopython
      numpy
      pytestCheckHook
    ]
    ++ [
      addBinToPathHook
    ];

  pytestFlagsArray = [ "../tests" ];

  passthru.tests = {
    version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Macromolecular crystallography library and utilities";
    homepage = "https://github.com/project-gemmi/gemmi";
    changelog = "https://github.com/project-gemmi/gemmi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "gemmi";
    platforms = lib.platforms.unix;
  };
})
