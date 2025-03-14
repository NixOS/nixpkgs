{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  autoconf,
  automake,
  mpi,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hp2p";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "cea-hpc";
    repo = "hp2p";
    tag = finalAttrs.version;
    hash = "sha256-Rrqb6M9E3WNuxhJXYfBrrv3sFQ2avU33gLZNUtU9Yuc=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [
    autoconf
    automake
    python3Packages.wrapPython
  ];
  buildInputs =
    [ mpi ]
    ++ (with python3Packages; [
      python
      plotly
    ]);
  pythonPath = (with python3Packages; [ plotly ]);

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
    export CC=mpicc
    export CXX=mpic++
  '';

  postInstall = ''
    wrapPythonPrograms
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "MPI based benchmark for network diagnostics";
    homepage = "https://github.com/cea-hpc/hp2p";
    changelog = "https://github.com/cea-hpc/hp2p/releases/tag/${finalAttrs.version}";
    platforms = lib.platforms.unix;
    license = lib.licenses.cecill-c;
    maintainers = [ lib.maintainers.bzizou ];
    mainProgram = "hp2p.exe";
    badPlatforms = [
      # hp2p_algo_cpp.cpp:38:10: error: no member named 'random_shuffle' in namespace 'std'
      lib.systems.inspect.patterns.isDarwin
    ];
  };
})
