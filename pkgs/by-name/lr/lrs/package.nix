{
  lib,
  stdenv,
  fetchurl,
  gmp,
  llvmPackages,
}:

stdenv.mkDerivation {
  pname = "lrs";
  version = "7.3";

  src = fetchurl {
    url = "https://cgm.cs.mcgill.ca/~avis/C/lrslib/archive/lrslib-073.tar.gz";
    sha256 = "sha256-xJpOvYVhg0c9HVpieF/N/hBX1dZx1LlvOhJQ6xr+ToM=";
  };

  patches = [
    # fix passing argument 2 of 'signal' from incompatible pointer type error
    ./fix-signal-handler-type.patch
  ];

  # https://github.com/macports/macports-ports/blob/master/math/lrslib/Portfile
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace-fail "-shared -Wl,-soname=" "-dynamiclib -install_name $out/lib/"
  '';

  buildInputs = [
    gmp
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CC:=$(CC)"
  ];

  meta = {
    description = "Implementation of the reverse search algorithm for vertex enumeration/convex hull problems";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    homepage = "http://cgm.cs.mcgill.ca/~avis/C/lrs.html";
  };
}
