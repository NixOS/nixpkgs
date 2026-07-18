{
  lib,
  stdenv,
  fetchFromGitHub,

  buildType ? "meson",

  # nativeBuildInputs
  asciidoctor,
  gfortran,
  pkg-config,
  python3,
  # meson:
  meson,
  ninja,
  # cmake:
  cmake,

  # buildInputs
  mstore,
  test-drive,
  blas,
  lapack,

  # propagatedBuildInputs
  mctc-lib,

  # passthru
  nix-update-script,
}:

assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);
stdenv.mkDerivation (finalAttrs: {
  pname = "numsa";
  version = "0.2.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = "numsa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PAzxeYyg/9P/3YFxKzM4ZFm2xT0AGap6q8/ei8jD/3M=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Use nixpkgs' mstore instead of building it from source
    ./use-external-mstore.patch
  ];

  postPatch = ''
    substituteInPlace config/install-mod.py \
      --replace-fail "/usr/bin/env python" "${lib.getExe python3}"
  '';

  nativeBuildInputs = [
    asciidoctor
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
    mstore # only needed to build the bundled test suite
    test-drive
  ];

  propagatedBuildInputs = [
    mctc-lib
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Solvent accessible surface area calculation";
    homepage = "https://github.com/grimme-lab/numsa";
    changelog = "https://github.com/grimme-lab/numsa/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
})
