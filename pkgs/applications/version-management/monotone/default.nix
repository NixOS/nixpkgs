{ lib, stdenv, fetchurl, boost, zlib, botan, libidn
, lua, pcre, sqlite, perl, pkg-config, expect
, bzip2, gmp, openssl
}:

let
  version = "1.1";
  perlVersion = lib.getVersion perl;
in

assert perlVersion != "";

stdenv.mkDerivation rec {
  pname = "monotone";
  inherit version;

  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.bz2";
    sha256 = "124cwgi2q86hagslbk5idxbs9j896rfjzryhr6z63r6l485gcp7r";
  };

  patches = [ ./monotone-1.1-Adapt-to-changes-in-pcre-8.42.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ boost zlib botan libidn lua pcre sqlite expect
    openssl gmp bzip2 ];

  postInstall = ''
    mkdir -p $out/share/${pname}-${version}
    cp -rv contrib/ $out/share/${pname}-${version}/contrib
    mkdir -p $out/${perl.libPrefix}/${perlVersion}
    cp -v contrib/Monotone.pm $out/${perl.libPrefix}/${perlVersion}
  '';

  #doCheck = true; # some tests fail (and they take VERY long)

  meta = with lib; {
    description = "A free distributed version control system";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
