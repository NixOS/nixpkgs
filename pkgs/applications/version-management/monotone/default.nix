{ stdenv, fetchurl, boost, zlib, botan, libidn
, lua, pcre, sqlite, perl, pkgconfig, expect
, bzip2, gmp, openssl
}:

let
  version = "1.1";
  perlVersion = (builtins.parseDrvName perl.name).version;
in

assert perlVersion != "";

stdenv.mkDerivation rec {
  name = "monotone-${version}";

  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.bz2";
    sha256 = "124cwgi2q86hagslbk5idxbs9j896rfjzryhr6z63r6l485gcp7r";
  };

  patches = [ ];

  buildInputs = [ boost zlib botan libidn lua pcre sqlite pkgconfig expect 
    openssl gmp bzip2 ];

  postInstall = ''
    mkdir -p $out/share/${name}
    cp -rv contrib/ $out/share/${name}/contrib
    mkdir -p $out/lib/perl5/site_perl/${perlVersion}
    cp -v contrib/Monotone.pm $out/lib/perl5/site_perl/${perlVersion}
  '';

  #doCheck = true; # some tests fail (and they take VERY long)

  meta = {
    description = "A free distributed version control system";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
