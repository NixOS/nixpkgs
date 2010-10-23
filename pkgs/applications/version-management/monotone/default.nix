{stdenv, fetchurl, boost, zlib, botan, libidn,
  lua, pcre, sqlite, perl, pkgconfig}:

let 
  version = "0.48.1";
in stdenv.mkDerivation rec {
  name = "monotone-${version}";
  inherit perl;
  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.gz";
    sha256 = "e5ab4917866d2c597f99577554549b7c4cda9895be7a5dd0469f1c7798fe3c10";
  };
  buildInputs = [boost zlib botan libidn lua pcre sqlite pkgconfig];
  postInstall = ''
    ensureDir $out/share/${name}
    cp -rv contrib/ $out/share/${name}/contrib
    ensureDir $out/lib/perl5/site_perl/''${perl##*-perl-}
    cp -v contrib/Monotone.pm $out/lib/perl5/site_perl/''${perl##*-perl-}
  '';
  meta = {
    maintainers = [stdenv.lib.maintainers.raskin];
  };
}
