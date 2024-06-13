{ lib
, stdenv
, fetchFromGitHub
, cmake
, gvm-libs
, pkg-config
, gnutls
, glib
, doxygen
, git
, libbsd
, libical
, libpkgconf
, gpgme
, util-linux
, libselinux
, libsepol
, libidn2
, graphviz
, icu
, p11-kit
, pcre2
, libxslt
, libtasn1
, installShellFiles
, xmltoman
, postgresql
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gvmd";
  version = "23.4.0";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "gvmd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Bxq6o98viMMwt2eoiZgPDTYqD/z6jRWYLgH/ZJvkpV4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
    installShellFiles
  ];

  buildInputs = [
    libxslt
    postgresql
    pcre2
    libbsd
    libidn2
    gvm-libs
    graphviz
    gnutls
    glib
    libtasn1
    icu
    libical
    gpgme
    glib
    libsepol
    libselinux
    util-linux
    p11-kit
    postgresql
    git
    xmltoman
    gpgme
    libpkgconf
  ];

  strictDeps = true;

  prePatch = ''
    substituteInPlace src/sql_pg.c --replace-warn "#include <postgresql/libpq-fe.h>" "#include <${postgresql}/include/libpq-fe.h>";
  '';

  cmakeFlags = [
    "-DSYSCONFDIR=etc"
  ];

  postBuilPhase = ''
    ln -s $out/lib/systemd/system/gvmd.service $out/etc/systemd/system/multi-user.target.wants/gvmd.service
  '';

  postInstall = ''
    installManPage $src/doc/gvm-manage-certs.1
    installManPage $src/doc/gvmd.8
    mkdir -p \
      $out/var/log/gvm \
      $out/var/lib/openvas/plugins \
      $out/var/lib/gvm/cert-data \
      $out/var/lib/gvm/users \
      $out/var/lib/gvm/scap-data \
      $out/var/lib/gvm/CA \
      $out/var/lib/gvm/private/CA \
      $out/var/lib/gvm/data-objects \
      $out/var/lib/gvm/feed-update.lock \
      $out/run/gvmd/gvmd.pid
  '';

    meta = with lib; {
    description = "The central management service between security scanners and the user clients";
    homepage = "https://github.com/greenbone/gvmd";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "gvmd";
    platforms = platforms.all;
  };
    })
