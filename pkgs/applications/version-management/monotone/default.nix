{stdenv, fetchurl, boost, zlib, botan, libidn,
  lua, pcre, sqlite, perl, pkgconfig}:

let 
  version = "0.99";
in stdenv.mkDerivation rec {
  name = "monotone-${version}";
  inherit perl;
  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.gz";
    sha256 = "fa677f09169afb71452598ce92ea376fe06037d17bfe650fb6aed17cead11453";
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
