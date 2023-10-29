{ lib
, stdenv
, fetchurl
, autoreconfHook
, disarchive
, git
, glibcLocales
, guile
, guile-avahi
, guile-gcrypt
, guile-git
, guile-gnutls
, guile-json
, guile-lib
, guile-lzlib
, guile-lzma
, guile-semver
, guile-ssh
, guile-sqlite3
, guile-zlib
, guile-zstd
, help2man
, makeWrapper
, pkg-config
, po4a
, scheme-bytestructures
, texinfo
, bzip2
, libgcrypt
, sqlite

, stateDir ? "/var"
, storeDir ? "/gnu/store"
, confDir ? "/etc"
}:

stdenv.mkDerivation rec {
  pname = "guix";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://gnu/guix/guix-${version}.tar.gz";
    hash = "sha256-Q8dpy/Yy7wVEmsH6SMG6FSwzSUxqvH5HE3u6eyFJ+KQ=";
  };

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
  ];

  configureFlags = [
    "--with-store-dir=${storeDir}"
    "--localstatedir=${stateDir}"
    "--sysconfdir=${confDir}"
    "--with-bash-completion-dir=$(out)/etc/bash_completion.d"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f \
        --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
        --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH"
    done
  '';

  meta = with lib; {
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
    homepage = "http://www.gnu.org/software/guix";
    license = licenses.gpl3Plus;
    mainProgram = "guix";
    maintainers = with maintainers; [ cafkafk foo-dogsquared ];
    platforms = platforms.linux;
  };
}
