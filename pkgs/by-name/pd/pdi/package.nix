{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  python3,
  cmake,
  gfortran,
  pkg-config,
  hdf5-mpi,
  zpp,

  # buildInputs
  gbenchmark,
  libyaml,
  mpi,
  spdlog,

  # passthru
  nix-update-script,
  testers,
  pdi,
}:
let
  python = python3.withPackages (
    p: with p; [
      distutils
      setuptools
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "pdi";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "pdidev";
    repo = "pdi";
    tag = version;
    hash = "sha256-l4vKWIitP0BqSRPxpv0UgjAOgHJ3Aecm1hT+f9BeqRA=";
  };

  # Current hdf5 version in nixpkgs is 1.14.4.3 which is 4 numbers long and doesn't match the 3 number regex. :')
  # Patch it to make it match a 4 number-long version.
  postPatch = ''
    substituteInPlace plugins/decl_hdf5/cmake/FindHDF5.cmake \
      --replace-fail '"H5_VERSION[ \t]+\"([0-9]+\\.[0-9]+\\.[0-9]+)' '"H5_VERSION[ \t]+\"([0-9]+\\.[0-9]+\\.[0-9]+(\\.[0-9]+)*)'
  '';

  nativeBuildInputs = [
    cmake
    gfortran
    pkg-config
    python
    hdf5-mpi
    zpp
  ];

  buildInputs = [
    gbenchmark
    hdf5-mpi
    libyaml
    mpi
    spdlog
  ];

  cmakeFlags = [
    # Force using nix gbenchmark instead of vendored version
    "-DUSE_benchmark=SYSTEM"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = pdi;
      command = "pdirun";
    };
  };

  meta = {
    description = "PDI supports loose coupling of simulation codes with data handling libraries";
    homepage = "https://pdi.dev/master/";
    changelog = "https://github.com/pdidev/pdi/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    mainProgram = "pdirun";
    maintainers = with lib.maintainers; [ GaetanLepage ];
    badPlatforms = [
      # fatal error: 'link.h' file not found
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
