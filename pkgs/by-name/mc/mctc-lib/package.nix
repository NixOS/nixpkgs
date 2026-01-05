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
  jonquil,
}:

assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);

stdenv.mkDerivation rec {
  pname = "mctc-lib";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = "mctc-lib";
    rev = "v${version}";
    hash = "sha256-rlwUNeuLzgSWZXDKCFS/H82+oH23tEzhhILqC/ZV6PI=";
  };

  patches = [
    # Allow dynamically linked jonquil as dependency. That then additionally
    # requires linking in toml-f
    ./meson.patch

    # Fix wrong generation of package config include paths
    ./cmake.patch
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

  buildInputs = [
    jonquil
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  postPatch = ''
    patchShebangs --build config/install-mod.py
  '';

  meta = with lib; {
    description = "Modular computation tool chain library";
    mainProgram = "mctc-convert";
    homepage = "https://github.com/grimme-lab/mctc-lib";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
