{ stdenv, fetchurl, xlibsWrapper, motif, libXpm }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "nedit-5.6a";
  
  src = fetchurl {
    url = "mirror://sourceforge/nedit/nedit-source/${name}-src.tar.gz";
    sha256 = "1v8y8vwj3kn91crsddqkz843y6csgw7wkjnd3zdcb4bcrf1pjrsk";
  };

  buildInputs = [ xlibsWrapper motif libXpm ];

  buildFlags = if stdenv.isLinux then "linux" else "";

  NIX_CFLAGS_COMPILE="-DBUILD_UNTESTED_NEDIT -L${motif}/lib";

  installPhase = ''
    mkdir -p $out/bin
    cp -p source/nedit source/nc $out/bin
  '';

  meta = {
    homepage = http://www.nedit.org;
  };
}
