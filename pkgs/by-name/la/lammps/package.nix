{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  pkg-config,
  cmake,
  python3,

  # buildInputs
  libpng,
  gzip,
  fftw,
  blas,
  lapack,

  # Available list of packages can be found near here:
  #
  # - https://github.com/lammps/lammps/blob/develop/cmake/CMakeLists.txt#L222
  # - https://docs.lammps.org/Build_extras.html
  packages ? {
    ASPHERE = true;
    BODY = true;
    CLASS2 = true;
    COLLOID = true;
    COMPRESS = true;
    CORESHELL = true;
    DIPOLE = true;
    GRANULAR = true;
    KSPACE = true;
    MANYBODY = true;
    MC = true;
    MISC = true;
    MOLECULE = true;
    OPT = true;
    PERI = true;
    QEQ = true;
    REPLICA = true;
    RIGID = true;
    SHOCK = true;
    ML-SNAP = true;
    SRD = true;
    REAXFF = true;
    PYTHON = true;
  },
  # Extra cmakeFlags to add as "-D${attr}=${value}"
  extraCmakeFlags ? { },
  # Extra `buildInputs` - meant for packages that require more inputs
  extraBuildInputs ? [ ],
  extraNativeBuildInputs ? [ ],

  # passthru
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "22Jul2025_update5";
  pname = "lammps";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "lammps";
    repo = "lammps";
    tag = "stable_${finalAttrs.version}";
    hash = "sha256-kI4CubDgXwnDDeXNan88RzG+iGMJMnsqfpfhWtJFhAI=";
  };
  preConfigure = ''
    cd cmake
  '';
  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ extraNativeBuildInputs
  ++ lib.optionals packages.PYTHON [
    python3
  ];

  passthru = {
    inherit packages;
    inherit extraCmakeFlags;
    inherit extraBuildInputs;
    inherit extraNativeBuildInputs;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "stable_(.*)"
      ];
    };
  };
  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ]
  ++ (lib.mapAttrsToList (n: v: lib.cmakeBool "PKG_${n}" v) packages)
  ++ (lib.mapAttrsToList (n: v: "-D${n}=${v}") extraCmakeFlags);

  buildInputs = [
    fftw
    libpng
    blas
    lapack
    gzip
  ]
  ++ lib.optionals packages.PYTHON [ python3 ]
  ++ extraBuildInputs;

  postInstall = ''
    # For backwards compatibility
    ln -s $out/bin/lmp $out/bin/lmp_serial
    # Install vim and neovim plugin
    install -Dm644 ../../tools/vim/lammps.vim $out/share/vim-plugins/lammps/syntax/lammps.vim
    install -Dm644 ../../tools/vim/filetype.vim $out/share/vim-plugins/lammps/ftdetect/lammps.vim
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/lammps $out/share/nvim/site
  '';

  meta = {
    description = "Classical Molecular Dynamics simulation code";
    longDescription = ''
      LAMMPS is a classical molecular dynamics simulation code designed to
      run efficiently on parallel computers. It was developed at Sandia
      National Laboratories, a US Department of Energy facility, with
      funding from the DOE. It is an open-source code, distributed freely
      under the terms of the GNU Public License (GPL).
    '';
    homepage = "https://www.lammps.org";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    # compiling lammps with 64 bit support blas and lapack might cause runtime
    # segfaults. In anycase both blas and lapack should have the same #bits
    # support.
    broken = (blas.isILP64 && lapack.isILP64);
    maintainers = with lib.maintainers; [
      costrouc
      doronbehar
    ];
    mainProgram = "lmp";
  };
})
