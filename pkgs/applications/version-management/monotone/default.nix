{stdenv, fetchurl, boost, zlib, botan, libidn,
  lua, pcre, sqlite, perl, lib}:

let 
  version = "0.46";
in stdenv.mkDerivation rec {
  name = "monotone-${version}";
  inherit perl;
  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.gz";
    sha256 = "1pla2fvkmfbrzfbdqd2jjghldpxl9iq81pwwkwaxa7n57snbvq61";
  };
  buildInputs = [boost zlib botan libidn lua pcre sqlite];
  preConfigure = ''
    export sqlite_LIBS=-lsqlite3
    export NIX_LDFLAGS="$NIX_LDFLAGS -ldl"
  '';
  postInstall = ''
    ensureDir $out/share/${name}
    cp -r contrib/ $out/share/${name}/contrib
    ensureDir $out/lib/perl5/site_perl/''${perl##*-perl-}
    cp contrib/Monotone.pm $out/lib/perl5/site_perl/''${perl##*-perl-}
  '';
  meta = {
    maintainers = [lib.maintainers.raskin];
  };
}
