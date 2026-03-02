{
  lib,
  stdenv,
  fetchgit,
  libmowgli,
  pkg-config,
  git,
  gettext,
  pcre,
  libidn,
  libxcrypt,
  cracklib,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atheme";
  version = "7.2.12";

  src = fetchgit {
    url = "https://github.com/atheme/atheme.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KAC1ZPNo4TqfVryKOYYef8cRWRgFmyEdvl1bgvpGNiM=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    pkg-config
    git
    gettext
  ];
  buildInputs = [
    libmowgli
    pcre
    libidn
    libxcrypt
    cracklib
    openssl
  ];

  configureFlags = [
    "--with-pcre"
    "--with-libidn"
    "--with-cracklib"
    "--enable-large-net"
    "--enable-contrib"
    "--enable-reproducible-builds"
  ];

  meta = {
    description = "Set of services for IRC networks";
    homepage = "https://atheme.github.io/";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ leo60228 ];
  };
})
