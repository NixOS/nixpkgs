{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "spooles";
  version = "2.2";

  src = fetchurl {
    url = "http://www.netlib.org/linalg/spooles/spooles.${version}.tgz";
    sha256 = "1pf5z3vvwd8smbpibyabprdvcmax0grzvx2y0liy98c7x6h5jid8";
  };

  sourceRoot = ".";

  patches = [
    ./spooles.patch
    # fix compiler error where NULL is used as a zero parameter
    ./transform.patch
    # use proper format specifier for size_t
    ./allocate.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace makefile --replace "-Wl,-soname," "-Wl,-install_name,$out/lib/"
  '';

  buildPhase = ''
    make lib
  '';

  installPhase = ''
    mkdir -p $out/lib $out/include/spooles
    cp libspooles.a libspooles.so.2.2 $out/lib/
    ln -s libspooles.so.2.2 $out/lib/libspooles.so.2
    ln -s libspooles.so.2 $out/lib/libspooles.so
    for h in *.h; do
      if [ $h != 'MPI.h' ]; then
         cp $h $out/include/spooles
         d=`basename $h .h`
         if [ -d $d ]; then
            mkdir $out/include/spooles/$d
            cp $d/*.h $out/include/spooles/$d
         fi
      fi
    done
  '';

  nativeBuildInputs = [ perl ];

  meta = with lib; {
    homepage = "http://www.netlib.org/linalg/spooles/";
    description = "Library for solving sparse real and complex linear systems of equations";
    license = licenses.publicDomain;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
