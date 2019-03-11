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

  patches = [ ./monotone-1.1-Adapt-to-changes-in-pcre-8.42.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost zlib botan libidn lua pcre sqlite expect
    openssl gmp bzip2 ];

  postInstall = ''
    mkdir -p $out/share/${name}
    cp -rv contrib/ $out/share/${name}/contrib
    mkdir -p $out/${perl.libPrefix}/${perlVersion}
    cp -v contrib/Monotone.pm $out/${perl.libPrefix}/${perlVersion}
  '';

  #doCheck = true; # some tests fail (and they take VERY long)

  meta = with stdenv.lib; {
    description = "A free distributed version control system";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
