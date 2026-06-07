{
  lib,
  stdenv,
  fetchFromGitHub,
  libmowgli,
  pkg-config,
  git,
  gettext,
  pcre2,
  libidn,
  libxcrypt,
  cracklib,
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atheme";
  version = "7.2.12-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "atheme";
    repo = "atheme";
    rev = "23071cdf2c7b20210799218b485f97f06311b41f";
    hash = "sha256-e7pD4ZXQ3irrpJJSDRuJu2pVMjxVe8AUzzVL5yCb9PA=";
    # for modules and pinned libmowgli
    fetchSubmodules = true;
    # configure checks for git tree
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    pkg-config
    git
    gettext
  ];

  buildInputs = [
    libmowgli
    pcre2
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

  enableParallelBuilding = true;

  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Set of services for IRC networks";
    homepage = "https://atheme.github.io/";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ leo60228 ];
  };
})
