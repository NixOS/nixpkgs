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
  version = "7.2.12-unstable-2026-11-10";

  src = fetchFromGitHub {
    owner = "atheme";
    repo = "atheme";
    rev = "bf55352ddf7ecdacc9c3f7058c5ba05f28887676";
    hash = "sha256-bGEtRkTJb9umb2yPr/8I3CwsOCKlvJD+PTJ/zoTETOo=";
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
