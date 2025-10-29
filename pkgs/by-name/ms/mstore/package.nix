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
  python3,
  mctc-lib,
}:

assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);

stdenv.mkDerivation rec {
  pname = "mstore";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = "mstore";
    rev = "v${version}";
    hash = "sha256-zfrxdrZ1Um52qTRNGJoqZNQuHhK3xM/mKfk0aBLrcjw=";
  };

  patches = [
    # Fix wrong generation of package config include paths
    ./pkgconfig.patch
  ];

  nativeBuildInputs = [
    gfortran
    pkg-config
    python3
  ]
  ++ lib.optionals (buildType == "meson") [
    meson
    ninja
  ]
  ++ lib.optional (buildType == "cmake") cmake;

  buildInputs = [ mctc-lib ];

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    patchShebangs --build config/install-mod.py
  '';

  meta = with lib; {
    description = "Molecular structure store for testing";
    license = licenses.asl20;
    homepage = "https://github.com/grimme-lab/mstore";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
