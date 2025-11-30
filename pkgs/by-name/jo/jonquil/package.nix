{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  buildType ? "meson",
  meson,
  ninja,
  cmake,
  pkg-config,
  test-drive,
  toml-f,
}:

assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);

stdenv.mkDerivation rec {
  pname = "jonquil";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "toml-f";
    repo = "jonquil";
    rev = "v${version}";
    hash = "sha256-2JCTHA0nyA7xE0IA+LNrEAulHU2eIbNRvFGQ7YSQMRE=";
  };

  patches = [
    # Fix wrong generation of package config include paths
    ./cmake.patch
  ];

  nativeBuildInputs = [
    gfortran
    pkg-config
  ]
  ++ lib.optionals (buildType == "meson") [
    meson
    ninja
  ]
  ++ lib.optional (buildType == "cmake") cmake;

  buildInputs = [
    test-drive
  ];

  propagatedBuildInputs = [
    toml-f
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = with lib; {
    description = "JSON parser on top of TOML implementation";
    license = with licenses; [
      asl20
      mit
    ];
    homepage = "https://github.com/toml-f/jonquil";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
