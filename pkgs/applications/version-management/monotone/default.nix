{ stdenv, fetchurl, boost, zlib, botan, libidn
, lua, pcre, sqlite, perl, pkgconfig }:

let
  version = "1.0";
  perlVersion = (builtins.parseDrvName perl.name).version;
in

assert perlVersion != "";

stdenv.mkDerivation rec {
  name = "monotone-${version}";

  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.bz2";
    sha256 = "5c530bc4652b2c08b5291659f0c130618a14780f075f981e947952dcaefc31dc";
  };

  buildInputs = [boost zlib botan libidn lua pcre sqlite pkgconfig];

  postInstall = ''
    mkdir -p $out/share/${name}
    cp -rv contrib/ $out/share/${name}/contrib
    mkdir -p $out/lib/perl5/site_perl/${perlVersion}
    cp -v contrib/Monotone.pm $out/lib/perl5/site_perl/${perlVersion}
  '';

  meta = {
    description = "A free distributed version control system";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
