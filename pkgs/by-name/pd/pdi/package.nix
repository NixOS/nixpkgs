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
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "pdidev";
    repo = "pdi";
    rev = "refs/tags/${version}-gh";
    hash = "sha256-VTbXsUUJb/6zNyn4QXNHajgzzgjSwdW/d+bTSDcpRaE=";
  };

  # Current hdf5 version in nixpkgs is 1.14.4.3 which is 4 numbers long and doesn't match the 3 number regex. :')
  # Patch it to make it match a 4 number-long version.
  postPatch = ''
    substituteInPlace plugins/decl_hdf5/cmake/FindHDF5.cmake \
      --replace-fail '"H5_VERSION[ \t]+\"([0-9]+\\.[0-9]+\\.[0-9]+)' '"H5_VERSION[ \t]+\"([0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)'
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
    license = lib.licenses.bsd3;
    mainProgram = "pdirun";
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
