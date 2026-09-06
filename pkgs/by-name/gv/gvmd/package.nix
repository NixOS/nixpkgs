{
  cmake,
  doxygen,
  fetchFromGitHub,
  git,
  glib,
  gnutls,
  gpgme,
  graphviz,
  gvm-libs,
  icu,
  lib,
  libbsd,
  libical,
  libidn2,
  libpkgconf,
  libselinux,
  libsepol,
  libtasn1,
  libxslt,
  openvas-scanner,
  ospd-openvas,
  p11-kit,
  perl538Packages,
  pcre2,
  pkg-config,
  postgresql,
  stdenv,
  util-linux,
  xmltoman,
}:

stdenv.mkDerivation rec {
  pname = "gvmd";
  version = "23.4.0";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "gvmd";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bxq6o98viMMwt2eoiZgPDTYqD/z6jRWYLgH/ZJvkpV4=";
  };

  prePatch = ''
    substituteInPlace src/sql_pg.c \
      --replace-fail "#include <postgresql/libpq-fe.h>" "#include <libpq-fe.h>"
    substituteInPlace doc/CMakeLists.txt \
      --replace-fail "share/doc/gvm/html/" "\''${GMP_DIR}/doc/gvm/html/" \
      --replace-fail "share/man/man8/" "\''${GVMD_MAN_DIR}/man/man8/"
  '';

  configurePhase = ''
    runHook preConfigure

    cmake -DSYSCONFDIR=$out/etc \
      -DBINDIR=$out/bin \
      -DSBINDIR=$out/sbin \
      -DLIBDIR=$out/lib \
      -DLOCALSTATEDIR=$out/var \
      -DINCLUDEDIR=$out/include \
      -DGMP_DIR=$out/share \
      -DGVMD_MAN_DIR=$out/share \
      -DDATADIR=$out/share \
      -DGVM_SYSCONF_DIR=$out/etc/gvm \
      -DGVM_DATA_DIR=$out/share/gvm \
      -DGVM_STATE_DIR=$out/var/lib/gvm \
      -DGVMD_STATE_DIR=$out/var/lib/gvm/gvmd \
      -DGVM_LIB_INSTALL_DIR=$out/lib \
      -DGVMD_RUN_DIR=$out/run/gvmd \
      -DXSLTPROC_EXECUTABLE=${libxslt.bin}/bin/xsltproc \
      -DINSTALL_OLD_SYNC_SCRIPTS=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DSYSTEMD_SERVICE_DIR=$out/lib/systemd/system .

    runHook postConfigure
  '';

  postConfigure = ''
    mkdir -p \
      $out/var/lib/gvm/{scap-data,cert-data,data-objects}
  '';

  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      doxygen
      pkg-config
      util-linux
      xmltoman
    ]
    ++ (with perl538Packages; [
      XMLTwig
      XMLParser
    ])
    ++ lib.optional stdenv.isDarwin git;

  buildInputs = [
    glib
    gnutls
    gpgme
    graphviz
    gvm-libs
    icu
    libbsd
    libical
    libidn2
    libpkgconf
    libselinux
    libsepol
    libtasn1
    libxslt
    openvas-scanner
    ospd-openvas
    p11-kit
    pcre2
    postgresql
    xmltoman
  ];

  preFixup = ''
    substituteInPlace $out/lib/systemd/system/gvmd.service \
      --replace-fail "/run/ospd/ospd-openvas.sock" "${ospd-openvas}/run/ospd/ospd-openvas.sock"
  '';

  meta = {
    description = "The central management service between security scanners and the user clients";
    homepage = "https://github.com/greenbone/gvmd";
    changelog = "https://github.com/greenbone/gvmd/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "gvmd";
    platforms = lib.platforms.all;
  };
}
