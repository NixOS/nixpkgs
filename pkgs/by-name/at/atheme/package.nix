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
  version = "7.2.12-unstable-2026-08-18";

  src = fetchFromGitHub {
    owner = "atheme";
    repo = "atheme";
    rev = "88de242f4755394746444c7bd28da15127d976d2";
    hash = "sha256-fX86+8I96FiysiCNJNCFK682GM0T5UJHpA7FjqKNbnE=";
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
