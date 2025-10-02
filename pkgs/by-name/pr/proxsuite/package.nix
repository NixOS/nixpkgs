{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  nix-update-script,
  pythonSupport ? false,
  python3Packages,

  # nativeBuildInputs
  cmake,
  doxygen,
  graphviz,

  # propagatedBuildInputs
  cereal_1_3_2,
  eigen,
  jrl-cmakemodules,
  simde,

  # nativeCheckInputs
  ctestCheckHook,

  # checkInputs
  matio,

}:
stdenv.mkDerivation (finalAttrs: {
  pname = "proxsuite";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "simple-robotics";
    repo = "proxsuite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1+a5tFOlEwzhGZtll35EMFceD0iUOOQCbwJd9NcFDlk=";
  };

  outputs = [
    "doc"
    "out"
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCUMENTATION" true)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.pythonImportsCheckHook
  ];

  propagatedBuildInputs = [
    cereal_1_3_2
    eigen
    jrl-cmakemodules
    simde
  ]
  ++ lib.optionals pythonSupport [ python3Packages.nanobind ];

  nativeCheckInputs = [ ctestCheckHook ];

  checkInputs = [
    matio
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.numpy
    python3Packages.scipy
  ];

  ctestFlags = lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
    "--exclude-regex"
    "sparse maros meszaros using the API"
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Advanced Proximal Optimization Toolbox";
    homepage = "https://github.com/Simple-Robotics/proxsuite";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
