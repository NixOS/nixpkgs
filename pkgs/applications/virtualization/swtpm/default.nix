{ stdenv
, fetchFromGitHub
, expect
, fuse
, nettools
, python3Packages
, trousers
, tpm-tools
, gnutls
, openssl
, glib
, socat
, pkgconfig
, autoconf
, automake
, autoreconfHook
, libtool
, libtpms
, libtasn1
, libseccomp
, file
}:

stdenv.mkDerivation rec {
  pname = "swtpm";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "swtpm";
    rev = "v${version}";
    sha256 = "06frkaxdsnxy4a71ym9wd933fl7mvvnmxcm2jbqb8k5niz135p1x";
  };

  buildInputs = [
    expect
    fuse
    nettools
    python3Packages.python
    python3Packages.twisted
    trousers
    tpm-tools
    gnutls
    openssl
    glib
    socat
  ];
  nativeBuildInputs = [
    pkgconfig
    autoconf
    automake
    autoreconfHook

    libtool
    libtpms
    libtasn1
    libseccomp

    file
  ];

  meta = with stdenv.lib; {
    description = "Libtpms-based TPM emulator with socket, character device, and Linux CUSE interface.";
    homepage = "https://github.com/stefanberger/swtpm";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
