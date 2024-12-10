{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "ircd-hybrid";
  version = "8.2.45";

  src = fetchurl {
    url = "mirror://sourceforge/ircd-hybrid/ircd-hybrid-${version}.tgz";
    sha256 = "sha256-lRrgMqsEqHtH5gIzngfg0Gtuh71aTrM087OVvhT3XkQ=";
  };

  buildInputs = [
    openssl
    zlib
    libxcrypt
  ];

  configureFlags = [
    "--with-nicklen=100"
    "--with-topiclen=360"
    "--enable-openssl=${openssl.dev}"
  ];

  postInstall = "echo postinstall; mkdir -p \${out}/ ; rm -rf \${out}/logs ; ln -s /home/ircd \${out}/logs;";

  meta = {
    description = "IPv6-capable IRC server";
    platforms = lib.platforms.unix;
    homepage = "https://www.ircd-hybrid.org/";
  };
}
