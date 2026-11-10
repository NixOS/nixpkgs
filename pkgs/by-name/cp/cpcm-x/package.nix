{
  lib,
  stdenv,
  fetchFromGitHub,

  buildType ? "meson",

  gfortran,
  pkg-config,
  python3,
  meson,
  ninja,
  cmake,

  # buildInputs
  blas,
  lapack,
  test-drive,

  # propagatedBuildInputs
  mctc-lib,
  numsa,
  toml-f,

  nix-update-script,
}:

assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);
stdenv.mkDerivation (finalAttrs: {
  pname = "cpcm-x";
  version = "1.1.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = "CPCM-X";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FyPUECbcqUHoGq1LASvPF4qSUKQ5N/y1itq8e2wGliE=";
  };

  patches = [
    # The installed CMake package config links numsa::numsa transitively but
    # never re-discovers it, so consumers fail with "target numsa::numsa not
    # found". Add the missing find_dependency call.
    ./cmake-config-find-numsa.patch
  ];

  postPatch = ''
    substituteInPlace config/install-mod.py \
      --replace-fail "/usr/bin/env python" "${lib.getExe python3}"
  '';

  outputs = [
    "out"
    "dev"
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
  ++ lib.optionals (buildType == "cmake") [
    cmake
  ];

  buildInputs = [
    blas
    lapack
    # only needed to build the bundled test suite
    test-drive
  ];

  propagatedBuildInputs = [
    mctc-lib
    numsa
    toml-f
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extended conductor-like polarizable continuum solvation model";
    homepage = "https://github.com/grimme-lab/CPCM-X";
    changelog = "https://github.com/grimme-lab/CPCM-X/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "cpx";
    platforms = lib.platforms.linux;
  };
})
