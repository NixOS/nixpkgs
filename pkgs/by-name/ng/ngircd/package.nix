{
  lib,
  stdenv,
  fetchurl,
  zlib,
  openssl,
  pam,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ngircd";
  version = "28";

  src = fetchurl {
    url = "https://ngircd.barton.de/pub/ngircd/ngircd-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-tIujIKkx1EWuM1xH+IqUBqIPXHHGI77l93VdBSLUNe4=";
  };

  configureFlags = [
    "--with-syslog"
    "--with-zlib"
    "--with-pam"
    "--with-openssl"
    "--enable-ipv6"
    "--with-iconv"
  ];

  buildInputs = [
    zlib
    pam
    openssl
    libiconv
  ];

  meta = {
    description = "Next Generation IRC Daemon";
    mainProgram = "ngircd";
    homepage = "https://ngircd.barton.de";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
