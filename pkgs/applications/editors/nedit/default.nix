{ stdenv, fetchurl, xlibsWrapper, motif, libXpm }:

stdenv.mkDerivation rec {
  name = "nedit-5.6a";
  
  src = fetchurl {
    url = "mirror://sourceforge/nedit/nedit-source/${name}-src.tar.gz";
    sha256 = "1v8y8vwj3kn91crsddqkz843y6csgw7wkjnd3zdcb4bcrf1pjrsk";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [ xlibsWrapper motif libXpm ];

  buildFlags = if stdenv.isLinux then "linux" else
               # the linux config works fine on darwin too!
               if stdenv.isDarwin then "linux" else "";

  NIX_CFLAGS_COMPILE="-DBUILD_UNTESTED_NEDIT -L${motif}/lib";

  installPhase = ''
    mkdir -p $out/bin
    cp -p source/nedit source/nc $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = http://www.nedit.org;
    platforms = with platforms; linux ++ darwin;
  };
}
