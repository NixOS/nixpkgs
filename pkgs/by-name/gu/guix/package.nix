{
  lib,
  stdenv,
  fetchgit,
  graphviz,
  gettext,
  autoreconfHook,
  disarchive,
  git,
  glibcLocales,
  guile,
  guile-avahi,
  guile-gcrypt,
  guile-git,
  guile-gnutls,
  guile-json,
  guile-lib,
  guile-lzlib,
  guile-lzma,
  guile-semver,
  guile-ssh,
  guile-sqlite3,
  guile-zlib,
  guile-zstd,
  help2man,
  makeWrapper,
  pkg-config,
  po4a,
  scheme-bytestructures,
  slirp4netns,
  texinfo,
  bzip2,
  libgcrypt,
  sqlite,
  nixosTests,

  stateDir ? "/var",
  storeDir ? "/gnu/store",
  confDir ? "/etc",
}:
let
  rev = "30a5d140aa5a789a362749d057754783fea83dde";
in
stdenv.mkDerivation rec {
  pname = "guix";
  version = "1.4.0-unstable-2025-06-24";

  src = fetchgit {
    url = "https://codeberg.org/guix/guix.git";
    inherit rev;
    hash = "sha256-QsOYApnwA2hb1keSv6p3EpMT09xCs9uyoSeIdXzftF0=";
  };

  patches = [
    ./missing-cstdint-include.patch
  ];

  postPatch = ''
    sed nix/local.mk -i -E \
      -e "s|^sysvinitservicedir = .*$|sysvinitservicedir = $out/etc/init.d|" \
      -e "s|^openrcservicedir = .*$|openrcservicedir = $out/etc/openrc|"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    disarchive
    git
    graphviz
    gettext
    glibcLocales
    guile
    guile-avahi
    guile-gcrypt
    guile-git
    guile-gnutls
    guile-json
    guile-lib
    guile-lzlib
    guile-lzma
    guile-semver
    guile-ssh
    guile-sqlite3
    guile-zlib
    guile-zstd
    help2man
    makeWrapper
    pkg-config
    po4a
    scheme-bytestructures
    slirp4netns
    texinfo
  ];

  buildInputs = [
    bzip2
    guile
    libgcrypt
    sqlite
  ];

  propagatedBuildInputs = [
    disarchive
    guile-avahi
    guile-gcrypt
    guile-git
    guile-gnutls
    guile-json
    guile-lib
    guile-lzlib
    guile-lzma
    guile-semver
    guile-ssh
    guile-sqlite3
    guile-zlib
    guile-zstd
    scheme-bytestructures
    slirp4netns
  ];

  configureFlags = [
    "--with-store-dir=${storeDir}"
    "--localstatedir=${stateDir}"
    "--sysconfdir=${confDir}"
    "--with-bash-completion-dir=$(out)/etc/bash_completion.d"
  ];

  preAutoreconf = ''
    echo ${version} > .tarball-version
    ./bootstrap
  '';

  enableParallelBuilding = true;

  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f \
        --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
        --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH" \
        --prefix GUILE_EXTENSIONS_PATH : "${guile-ssh}/lib/guile/3.0/extensions"
    done
  '';

  passthru.tests = {
    inherit (nixosTests) guix;
  };

  meta = {
    description = "Functional package manager with a Scheme interface";
    longDescription = ''
      GNU Guix is a purely functional package manager for the GNU system, and a distribution thereof.
      In addition to standard package management features, Guix supports
      transactional upgrades and roll-backs, unprivileged package management,
      per-user profiles, and garbage collection.
      It provides Guile Scheme APIs, including high-level embedded
      domain-specific languages (EDSLs), to describe how packages are built
      and composed.
      A user-land free software distribution for GNU/Linux comes as part of
      Guix.
      Guix is based on the Nix package manager.
    '';
    homepage = "https://guix.gnu.org/";
    changelog = "https://codeberg.org/guix/guix/raw/commit/${rev}/NEWS";
    license = lib.licenses.gpl3Plus;
    mainProgram = "guix";
    maintainers = with lib.maintainers; [
      cafkafk
      foo-dogsquared
      hpfr
    ];
    platforms = lib.platforms.linux;
  };
}
