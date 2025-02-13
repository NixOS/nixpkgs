{
  cmake,
  doxygen,
  fetchFromGitHub,
  lib,
  pkg-config,
  pythonSupport ? false,
  python3Packages,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "example-robot-data";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "example-robot-data";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-IRmqeaN0EaIjYaibTEAR8KhixoNQsl6YydbGQRinP6w=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      doxygen
      pkg-config
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.python
      python3Packages.pythonImportsCheckHook
    ];

  propagatedBuildInputs = lib.optionals pythonSupport [ python3Packages.pinocchio ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport) ];

  doCheck = true;
  # The package expect to find an `example-robot-data/robots` folder somewhere
  # either in install prefix or in the sources
  # where it can find the meshes for unit tests
  preCheck = "ln -s source ../../${finalAttrs.pname}";
  pythonImportsCheck = [ "example_robot_data" ];

  meta = with lib; {
    description = "Set of robot URDFs for benchmarking and developed examples";
    homepage = "https://github.com/Gepetto/example-robot-data";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      nim65s
      wegank
    ];
    platforms = platforms.unix;
  };
})
