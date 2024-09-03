{ lib
, stdenv
, fetchFromGitHub
, readline
, xorg
, mpi
, cmake
, bison
, flex
, git
, perl
, gsl
, xcbuild
, python3
, useMpi ? false
, useIv ? true
, useCore ? false
, useRx3d ? false
}:
let
  inherit (lib.lists) optionals;
  inherit (lib.strings) cmakeBool;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "neuron";
  version = "8.2.6";

  # format is for pythonModule conversion
  format = "other";

  nativeBuildInputs = [
    cmake
    bison
    flex
    git
  ] ++ optionals useCore [ perl gsl ]
  ++ optionals stdenv.isDarwin [ xcbuild ];

  buildInputs = optionals useIv [
    xorg.libX11.dev
    xorg.libXcomposite.dev
    xorg.libXext.dev
  ];

  propagatedBuildInputs = [
    readline
    python3
    python3.pkgs.wheel
    python3.pkgs.setuptools
    python3.pkgs.scikit-build
    python3.pkgs.matplotlib
  ] ++ optionals useMpi [
    mpi
  ] ++ optionals useMpi [
    python3.pkgs.mpi4py
  ] ++ optionals useRx3d [
    python3.pkgs.cython_0 # NOTE: cython<3 is required as of 8.2.6
    python3.pkgs.numpy
  ];

  # Patch build shells for cmake (bin, src, cmake) and submodules (external)
  postPatch = ''
    patchShebangs ./bin ./src ./external ./cmake
    substituteInPlace external/coreneuron/extra/nrnivmodl_core_makefile.in \
      --replace-fail \
        "DESTDIR =" \
        "DESTDIR = $out"
  '';

  cmakeFlags = [
    (cmakeBool "NRN_ENABLE_INTERVIEWS" useIv)
    (cmakeBool "NRN_ENABLE_MPI" useMpi)
    (cmakeBool "NRN_ENABLE_CORENEURON" useCore)
    (cmakeBool "NRN_ENABLE_RX3D" useRx3d)
  ];

  postInstall = ''
    mkdir -p $out/${python3.sitePackages}
    mv $out/lib/python/* $out/${python3.sitePackages}/
    rm -rf $out/lib/python build
    for entry in $out/lib/*.so; do
      # remove references to build
      patchelf --set-rpath $(patchelf --print-rpath $entry | tr ':' '\n' | sed '/^\/build/d' | tr '\n' ':') $entry
    done
  '';

  src = fetchFromGitHub {
    owner = "neuronsimulator";
    repo = "nrn";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-xASBpsF8rIzrb5G+4Qi6rvWC2wqL7nAGlSeMsBAI6WM=";
  };

  meta = with lib; {
    description = "Simulation environment for empirically-based simulations of neurons and networks of neurons";
    longDescription = ''
      NEURON is a simulation environment for developing and exercising models of
      neurons and networks of neurons. It is particularly well-suited to problems where
      cable properties of cells play an important role, possibly including extracellular
      potential close to the membrane), and where cell membrane properties are complex,
      involving many ion-specific channels, ion accumulation, and second messengers
    '';
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = licenses.bsd3;
    homepage = "http://www.neuron.yale.edu/neuron";
    maintainers = with maintainers; [ adev davidcromp ];
    platforms = platforms.all;
  };
})
