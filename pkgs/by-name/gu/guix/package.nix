{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  fetchDebianPatch,
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
  texinfo,
  bzip2,
  libgcrypt,
  sqlite,
  nixosTests,

  stateDir ? "/var",
  storeDir ? "/gnu/store",
  confDir ? "/etc",
}:

stdenv.mkDerivation rec {
  pname = "guix";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://gnu/guix/guix-${version}.tar.gz";
    hash = "sha256-Q8dpy/Yy7wVEmsH6SMG6FSwzSUxqvH5HE3u6eyFJ+KQ=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-27297_1.patch";
      url = "https://git.savannah.gnu.org/cgit/guix.git/patch/?id=8f4ffb3fae133bb21d7991e97c2f19a7108b1143";
      hash = "sha256-xKo1h2uckC2pYHt+memekagfL6dWcF8gOnTOOW/wJUU=";
    })
    (fetchpatch {
      name = "CVE-2024-27297_2.patch";
      url = "https://git.savannah.gnu.org/cgit/guix.git/patch/?id=ff1251de0bc327ec478fc66a562430fbf35aef42";
      hash = "sha256-f4KWDVrvO/oI+4SCUHU5GandkGtHrlaM1BWygM/Qlao=";
    })
    # see https://guix.gnu.org/en/blog/2024/build-user-takeover-vulnerability
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "8";
      patch = "security/0101-daemon-Sanitize-failed-build-outputs-prior-to-exposi.patch";
      hash = "sha256-cbra/+K8+xHUJrCKRgzJCuhMBpzCSjgjosKAkJx7QIo=";
    })
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "8";
      patch = "security/0102-daemon-Sanitize-successful-build-outputs-prior-to-ex.patch";
      hash = "sha256-mOnlYtpIuYL+kDvSNuXuoDLJP03AA9aI2ALhap+0NOM=";
    })
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

  passthru.tests = {
    inherit (nixosTests) guix;
  };

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
    changelog = "https://git.savannah.gnu.org/cgit/guix.git/plain/NEWS?h=v${version}";
    license = licenses.gpl3Plus;
    mainProgram = "guix";
    maintainers = with maintainers; [
      cafkafk
      foo-dogsquared
    ];
    platforms = platforms.linux;
  };
}
