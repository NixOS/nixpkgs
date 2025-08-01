{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  libmhash,
  zlib,
  acl,
  attr,
  libselinux,
  pcre2,
  pkg-config,
  libgcrypt,
}:

stdenv.mkDerivation rec {
  pname = "aide";
  version = "0.19.1";

  src = fetchurl {
    url = "https://github.com/aide/aide/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-bfi/XwQD10r329uR6zyPYf4H6WRmnbjPoe5+TuPpC1I=";
  };

  buildInputs = [
    flex
    bison
    libmhash
    zlib
    acl
    attr
    libselinux
    pcre2
    libgcrypt
  ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = [
    "--with-posix-acl"
    "--with-selinux"
    "--with-xattr"
    "--sysconfdir=/etc"
  ];

  meta = {
    homepage = "https://aide.github.io/";
    changelog = "https://github.com/aide/aide/blob/v${version}/ChangeLog";
    description = "File and directory integrity checker";
    mainProgram = "aide";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.linux;
  };
}
