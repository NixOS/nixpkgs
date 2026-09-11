{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  nix-update-script,
  pythonSupport ? false,
  python3Packages,

  # buildInputs
  jrl-cmakemodules,
  llvmPackages,

  # propagatedBuildInputs
  cereal,
  eigen,
  simde,

  # nativeCheckInputs
  ctestCheckHook,

  # checkInputs
  catch2_3,
  matio,

}:
stdenv.mkDerivation (finalAttrs: {
  pname = "proxsuite";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "simple-robotics";
    repo = "proxsuite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zAYQJeUuLwNwyoV2QCpKp7YzJv7hLTwUQwMCWHYI5vo=";
  };

  outputs = [
    "doc"
    "out"
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_WITH_OPENMP_SUPPORT" true)
    (lib.cmakeBool "BUILD_WITH_VECTORIZATION_SUPPORT" true)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "GENERATE_PYTHON_STUBS" pythonSupport)
  ];

  strictDeps = true;

  nativeBuildInputs =
    jrl-cmakemodules.docsNativeBuildInputs
    ++ lib.optionals pythonSupport [
      python3Packages.python
      python3Packages.pythonImportsCheckHook
    ];

  buildInputs = [
    jrl-cmakemodules
  ]
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  propagatedBuildInputs = [
    cereal
    eigen
    simde
  ]
  ++ lib.optionals pythonSupport [ python3Packages.nanobind ];

  nativeCheckInputs = [ ctestCheckHook ];

  checkInputs = [
    catch2_3
    matio
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.numpy
    python3Packages.scipy
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  # Fontconfig error: No writable cache directories
  preBuild = "export XDG_CACHE_HOME=$(mktemp -d)";

  doCheck = true;
  pythonImportsCheck = [ "proxsuite" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Simple-Robotics/proxsuite/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Advanced Proximal Optimization Toolbox";
    homepage = "https://github.com/Simple-Robotics/proxsuite";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
