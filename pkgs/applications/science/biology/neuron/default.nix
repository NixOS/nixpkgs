{ lib
, stdenv
, fetchurl
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


stdenv.mkDerivation rec {
  pname = "neuron";
  version = "8.2.3";

  # format is for pythonModule conversion
  format = "other";

  nativeBuildInputs = [
    cmake
    bison
    flex
    git
  ] ++ lib.optionals useCore [ perl gsl ]
  ++ lib.optionals stdenv.isDarwin [ xcbuild ];

  buildInputs = lib.optionals useIv [
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
  ] ++ lib.optionals useMpi [
    mpi
  ] ++ lib.optionals useMpi [
    python3.pkgs.mpi4py
  ] ++ lib.optionals useRx3d [
    python3.pkgs.cython
    python3.pkgs.numpy
  ];

  patches = [ ./neuron_darwin_rpath.patch ];

  # Patch build shells for cmake (bin, src, cmake) and submodules (external)
  postPatch = ''
    patchShebangs ./bin ./src ./external ./cmake
    sed -e 's#DESTDIR =#DESTDIR = '"$out"'#' -i external/coreneuron/extra/nrnivmodl_core_makefile.in
  '';

  cmakeFlags = [
    "-DNRN_ENABLE_INTERVIEWS=${if useIv then "ON" else "OFF"}"
    "-DNRN_ENABLE_MPI=${if useMpi then "ON" else "OFF"}"
    "-DNRN_ENABLE_CORENEURON=${if useCore then "ON" else "OFF"}"
    "-DNRN_ENABLE_RX3D=${if useRx3d then "ON" else "OFF"}"
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

  src = fetchurl {
    url = "https://github.com/neuronsimulator/nrn/releases/download/${version}/full-src-package-${version}.tar.gz";
    sha256 = "sha256-k8+71BRfh+a73sZho6v0QFRxVmrfx6jqrgaqammdtDI=";
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
}
