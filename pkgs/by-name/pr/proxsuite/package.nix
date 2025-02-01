{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cereal_1_3_2,
  cmake,
  doxygen,
  eigen,
  fontconfig,
  graphviz,
  jrl-cmakemodules,
  simde,
  matio,
  pythonSupport ? false,
  python3Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "proxsuite";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "simple-robotics";
    repo = "proxsuite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iKc55WDHArmmIM//Wir6FHrNV84HnEDcBUlwnsbtMME=";
  };

  patches = [
    # Fix use of system cereal
    # This was merged upstream and can be removed on next release
    (fetchpatch {
      url = "https://github.com/Simple-Robotics/proxsuite/pull/352/commits/8305864f13ca7dff7210f89004a56652b71f8891.patch";
      hash = "sha256-XMS/zHFVrEp1P6aDlGrLbrcmuKq42+GdZRH9ObewNCY=";
    })
  ];

  outputs = [
    "doc"
    "out"
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_DOCUMENTATION" true)
      (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
      "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;ProxQP::dense: test primal infeasibility solving"
    ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ] ++ lib.optional pythonSupport python3Packages.pythonImportsCheckHook;
  propagatedBuildInputs = [
    cereal_1_3_2
    eigen
    jrl-cmakemodules
    simde
  ] ++ lib.optionals pythonSupport [ python3Packages.pybind11 ];
  checkInputs =
    [ matio ]
    ++ lib.optionals pythonSupport [
      python3Packages.numpy
      python3Packages.scipy
    ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=missing-template-arg-list-after-template-kw"
    ]
  );

  # Fontconfig error: No writable cache directories
  preBuild = "export XDG_CACHE_HOME=$(mktemp -d)";

  doCheck = true;
  pythonImportsCheck = [ "proxsuite" ];

  meta = {
    description = "The Advanced Proximal Optimization Toolbox";
    homepage = "https://github.com/Simple-Robotics/proxsuite";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
