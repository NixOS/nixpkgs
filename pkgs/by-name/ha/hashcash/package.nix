{
  lib,
  stdenv,
  fetchurl,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "hashcash";
  version = "1.22";

  buildInputs = [ openssl ];

  src = fetchurl {
    url = "http://www.hashcash.org/source/hashcash-${version}.tgz";
    sha256 = "15kqaimwb2y8wvzpn73021bvay9mz1gqqfc40gk4hj6f84nz34h1";
  };

  makeFlags = [
    "generic-openssl"
    "LIBCRYPTO=-lcrypto"
  ];

  installFlags = [
    "INSTALL_PATH=${placeholder "out"}/bin"
    "MAN_INSTALL_PATH=${placeholder "out"}/share/man/man1"
    "DOC_INSTALL_PATH=${placeholder "out"}/share/doc/hashcash-$(version)"
  ];

  meta = with lib; {
    description = "Proof-of-work algorithm used as spam and denial-of-service counter measure";
    homepage = "http://hashcash.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ kisonecat ];
  };
}
