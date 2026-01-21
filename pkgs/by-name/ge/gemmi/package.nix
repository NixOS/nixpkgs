{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  enablePython ? true,
  addBinToPathHook,
  python3Packages,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gemmi";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "project-gemmi";
    repo = "gemmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0MAY3mNHTv0ydtoVcJQKbOcSxCTvzH5S/5O82PjumKE=";
  };

  nativeBuildInputs = [
    cmake
  ]
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
      versionCheckHook
    ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Numerical precision error
    # self.assertTrue(numpy.allclose(data_f, abs(asu_val), atol=5e-5, rtol=0))
    # AssertionError: False is not true
    "test_reading"
  ];

  enabledTestPaths = [ "../tests" ];

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
