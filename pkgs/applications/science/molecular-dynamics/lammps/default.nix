{ lib
, stdenv
, fetchFromGitHub
, libpng
, gzip
, fftw
, blas
, lapack
, cmake
, cudaPackages
, pkg-config
# Available list of packages can be found near here:
#
# - https://github.com/lammps/lammps/blob/develop/cmake/CMakeLists.txt#L222
# - https://docs.lammps.org/Build_extras.html
, packages ? {
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
}
# Extra cmakeFlags to add as "-D${attr}=${value}"
, extraCmakeFlags ? {}
# Extra `buildInputs` - meant for packages that require more inputs
, extraBuildInputs ? []
}:

stdenv.mkDerivation (finalAttrs: {
  # LAMMPS has weird versioning convention. Updates should go smoothly with:
  # nix-update --commit lammps --version-regex 'stable_(.*)'
  version = "2Aug2023_update2";
  pname = "lammps";

  src = fetchFromGitHub {
    owner = "lammps";
    repo = "lammps";
    rev = "stable_${finalAttrs.version}";
    hash = "sha256-E918Jv6RAfXmHxyHZos2F7S8HFWzU6KjxDwXYNAYFMY=";
  };
  preConfigure = ''
    cd cmake
  '';
  nativeBuildInputs = [
    cmake
    pkg-config
    # Although not always needed, it is needed if cmakeFlags include
    # GPU_API=cuda, and it doesn't users that don't enable the GPU package.
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  passthru = {
    # Remove these at some point - perhaps after release 23.11. See discussion at:
    # https://github.com/NixOS/nixpkgs/pull/238771#discussion_r1235459961
    mpi = throw "`lammps-mpi.passthru.mpi` was removed in favor of `extraBuildInputs`";
    inherit packages;
    inherit extraCmakeFlags;
    inherit extraBuildInputs;
  };
  cmakeFlags = [
  ]
  ++ (builtins.map (p: "-DPKG_${p}=ON") (builtins.attrNames (lib.filterAttrs (n: v: v) packages)))
  ++ (lib.mapAttrsToList (n: v: "-D${n}=${v}") extraCmakeFlags)
  ;

  buildInputs = [
    fftw
    libpng
    blas
    lapack
    gzip
  ] ++ extraBuildInputs
  ;

  postInstall = ''
    # For backwards compatibility
    ln -s $out/bin/lmp $out/bin/lmp_serial
    # Install vim and neovim plugin
    install -Dm644 ../../tools/vim/lammps.vim $out/share/vim-plugins/lammps/syntax/lammps.vim
    install -Dm644 ../../tools/vim/filetype.vim $out/share/vim-plugins/lammps/ftdetect/lammps.vim
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/lammps $out/share/nvim/site
  '';

  meta = with lib; {
    description = "Classical Molecular Dynamics simulation code";
    longDescription = ''
      LAMMPS is a classical molecular dynamics simulation code designed to
      run efficiently on parallel computers. It was developed at Sandia
      National Laboratories, a US Department of Energy facility, with
      funding from the DOE. It is an open-source code, distributed freely
      under the terms of the GNU Public License (GPL).
      '';
    homepage = "https://www.lammps.org";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    # compiling lammps with 64 bit support blas and lapack might cause runtime
    # segfaults. In anycase both blas and lapack should have the same #bits
    # support.
    broken = (blas.isILP64 && lapack.isILP64);
    maintainers = [ maintainers.costrouc maintainers.doronbehar ];
    mainProgram = "lmp";
  };
})
