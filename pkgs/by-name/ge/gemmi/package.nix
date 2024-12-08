{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  enablePython ? true,
  python3Packages,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gemmi";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "project-gemmi";
    repo = "gemmi";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Y7gQSh9C7smoXuGWgpJI3hPIg06Jns+1dBpmMxuCrKE=";
  };

  nativeBuildInputs =
    [ cmake ]
    ++ lib.optionals enablePython (
      with python3Packages;
      [
        pybind11
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

  nativeInstallCheckInputs = [ python3Packages.pytestCheckHook ];

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
