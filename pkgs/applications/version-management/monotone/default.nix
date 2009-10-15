{stdenv, fetchurl, boost, zlib, botan, libidn,
  lua, pcre, sqlite, perl, lib}:

let 
  version = "0.45";
in stdenv.mkDerivation rec {
  name = "monotone-${version}";
  inherit perl;
  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.gz";
    sha256 = "64c734274715f392eb4a879172a11c0606d37c02b4a6f23045772af5f8e2a9ec";
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
