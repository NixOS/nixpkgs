{ stdenv
, fetchurl
, pkgconfig
, automake
, autoconf
, libtool
, ncurses
, readline
, which
, python ? null
, mpi ? null
, iv
}:

stdenv.mkDerivation rec {
  name = "neuron-${version}";
  version = "7.4";

  nativeBuildInputs = [ which pkgconfig automake autoconf libtool ];
  buildInputs = [ ncurses readline python mpi iv ];

  src = fetchurl {
    url = "http://www.neuron.yale.edu/ftp/neuron/versions/v${version}/nrn-${version}.tar.gz";
    sha256 = "1rid8cmv5mca0vqkgwahm0prkwkbdvchgw2bdwvx4adkn8bbl0ql";
  };

  patches = (stdenv.lib.optional (stdenv.isDarwin) [ ./neuron-carbon-disable.patch ]);

  # With LLVM 3.8 and above, clang (really libc++) gets upset if you attempt to redefine these...
  postPatch = stdenv.lib.optionalString stdenv.cc.isClang ''
    substituteInPlace src/gnu/neuron_gnu_builtin.h \
      --replace 'double abs(double arg);' "" \
      --replace 'float abs(float arg);' "" \
      --replace 'short abs(short arg);' "" \
      --replace 'long abs(long arg);' ""
  '';

  enableParallelBuilding = true;

  ## neuron install by default everything under prefix/${host_arch}/*
  ## override this to support nix standard file hierarchy
  ## without issues: install everything under prefix/
  preConfigure = ''
    ./build.sh
    export prefix="''${prefix} --exec-prefix=''${out}"
  '';

  configureFlags = with stdenv.lib;
                    [ "--with-readline=${readline}" "--with-iv=${iv}" ]
                    ++  optionals (python != null)  [ "--with-nrnpython=${python.interpreter}" ]
                    ++ (if mpi != null then ["--with-mpi" "--with-paranrn"]
                        else ["--without-mpi"]);


  postInstall = stdenv.lib.optionals (python != null) [ ''
    ## standardise python neuron install dir if any
    if [[ -d $out/lib/python ]]; then
        mkdir -p ''${out}/${python.sitePackages}
        mv ''${out}/lib/python/*  ''${out}/${python.sitePackages}/
    fi
  ''];

  propagatedBuildInputs = [ readline ncurses which libtool ];

  meta = with stdenv.lib; {
    description = "Simulation environment for empirically-based simulations of neurons and networks of neurons";

    longDescription = "NEURON is a simulation environment for developing and exercising models of
                neurons and networks of neurons. It is particularly well-suited to problems where
                cable properties of cells play an important role, possibly including extracellular
                potential close to the membrane), and where cell membrane properties are complex,
                involving many ion-specific channels, ion accumulation, and second messengers";

    license     = licenses.bsd3;
    homepage    = http://www.neuron.yale.edu/neuron;
    maintainers = [ maintainers.adev ];
    platforms   = platforms.all;
  };
}

