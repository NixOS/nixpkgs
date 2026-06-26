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

stdenv.mkDerivation (finalAttrs: {
  pname = "jonquil";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "toml-f";
    repo = "jonquil";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xKL3EWZaHdMAuUK7pL2vjfRk8Fq2uNL65TrGUyFQ5cc=";
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

  meta = {
    description = "JSON parser on top of TOML implementation";
    license = with lib.licenses; [
      asl20
      mit
    ];
    homepage = "https://github.com/toml-f/jonquil";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
