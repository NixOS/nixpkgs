{stdenv, fetchurl, boost, zlib, botan, libidn,
  lua, pcre, sqlite, perl, pkgconfig}:

let 
  version = "0.48";
in stdenv.mkDerivation rec {
  name = "monotone-${version}";
  inherit perl;
  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.gz";
    sha256 = "3149abf0e4433a0e14c5da805a04dbbc45b16086bc267d473b17e933407d839d";
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
