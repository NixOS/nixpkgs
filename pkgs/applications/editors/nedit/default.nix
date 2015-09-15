{ stdenv, fetchurl, xlibsWrapper, motif, libXpm }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "nedit-5.6";
  
  src = fetchurl {
    url = "mirror://sourceforge/nedit/nedit-source/${name}-src.tar.gz";
    sha256 = "023hwpqc57mnzvg6p7jda6193afgjzxzajlhwhqvk3jq2kdv6zna";
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
