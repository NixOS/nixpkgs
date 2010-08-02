{stdenv, fetchurl, boost, zlib, botan, libidn,
  lua, pcre, sqlite, perl, lib}:

let 
  version = "0.48";
in stdenv.mkDerivation rec {
  name = "monotone-${version}";
  inherit perl;
  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.gz";
    sha256 = "3149abf0e4433a0e14c5da805a04dbbc45b16086bc267d473b17e933407d839d";
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
