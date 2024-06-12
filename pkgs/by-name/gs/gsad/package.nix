{ lib
, stdenv
, fetchFromGitHub
, gnutls
, gnutar
, libgcrypt
, cmake
, glib
, libxml2
, libxslt
, pkg-config
, gettext
, doxygen
, gvm-libs
, libtasn1
, libidn2
, p11-kit
, python3Packages
, pcre2
, installShellFiles
, util-linux
, libselinux
, libsepol
, git
, libmicrohttpd
}:

stdenv.mkDerivation rec {
  pname = "gsa";
  version = "23.0.0";

  src1 = fetchFromGitHub {
    owner = "greenbone";
    repo = "gsa";
    rev = "v${version}";
    hash = "sha256-yA+B6fh8C07tGEoy/+FPvcvx3D1OfPig0Eoqv2oJfsA=";
  };

  src2 = fetchFromGitHub {
    owner = "greenbone";
    repo = "gsad";
    rev = "v22.9.1";
    hash = "sha256-FTB+YqsAi4EgCGMSbWmDLjh2NHzpyA9zpPMAzm90Thg=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs = [
    libxslt
    git
    gettext
    glib
    pcre2
    libgcrypt
    gnutls
    gnutar
    gvm-libs
    util-linux
    installShellFiles
    libmicrohttpd
    libidn2
    p11-kit
    libxml2
    libselinux
    libsepol
    python3Packages.polib
    libtasn1
  ];

  unpackPhase = ''
    mkdir -p $out/share/gvm/gsad/web
    mkdir -p $out/gsad
    cp -R $src1/* $out/share/gvm/gsad/web
    cp -R $src2/* $out/gsad
  '';

  cmakeFlags = [
    "-DGVMD_RUN_DIR=run/gvmd"
    "-DGSAD_RUN_DIR=run/gsad"
    "-DGSAD_DATA_DIR=share/gvm/gsad"
    "-DGSAD_CONFIG_DATA=etc/gvm"
    "-DLOGROTATE_DIR=etc/logrotate.d"
    "-DSYSCONFDIR=etc"
    "-DBINDIR=bin"
    "-DSBINDIR=sbin"
    "-DLIBDIR=lib"
    "-DLOCALSTATEDIR=var"
    "-DINCLUDEDIR=include"
    "-DDATADIR=share"
    "-DGVM_SYSCONF_DIR=etc/gvm"
    "-DGVM_DATA_DIR=share/gvm"
    "-DGVMD_DATA_DIR=share/gvmd"
    "-DGVM_STATE_DIR=var/lib/gvm"
    "-DGVMD_STATE_DIR=var/lib/gvm/gvmd"
    "-DGVM_LOG_DIR=var/log/gvm"
    "-DGVM_SCAP_RES_DIR=share/gvm/scap"
    "-DGVM_CERT_RES_DIR=share/gvm/cert"
    "-DGVM_CA_DIR=var/lib/gvm/gvmd/trusted_certs"
    "-DGVM_LIB_INSTALL_DIR=lib"
    "-DGVM_SCANNER_CERTIFICATE=var/lib/CA/servercert.pem"
    "-DGVM_SCANNER_KEY=var/lib/private/CA/serverkey.pem"
    "-DGVM_CLIENT_CERTIFICATE=var/lib/CA/clientcert.pem"
    "-DGVM_CLIENT_KEY=var/lib/private/CA/clientkey.pem"
    "-DGVM_CA_CERTIFICATE=var/lib/CA/cacert.pem"
    "-DGVMD_RUN_DIR=run/gvmd"
    "-DGSAD_PID_PATH=run/gvmd/gsad.pid"
  ];

  configurePhase = ''
    cd $out/gsad
    cmake -S $out/gsad -B ..
  '';

  preInstall = ''
    mkdir -p $out/etc/gvm
    mkdir -p $out/run/gvmd/gvmd.pid
    mkdir -p $out/run/gsad
    mkdir -p \
      $out/var/log/gvm \
      $out/var/lib/openvas/plugins \
      $out/var/lib/gvm/cert-data \
      $out/var/lib/gvm/users \
      $out/var/lib/gvm/scap-data \
      $out/var/lib/gvm/CA \
      $out/var/lib/gvm/private/CA \
      $out/var/lib/gvm/data-objects \
      $out/var/lib/gvm/feed-update.lock
    installManPage $src2/doc/gsad.8
  '';

  installPhase = ''
    runHook preInstall

    cd $out
    make
    make doc
    make DESTDIR=$out install
    rm -rf C* c* Makefile install*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Greenbone Security Assistant - The web frontend and web server for the Greenbone Community Edition";
    homepage = "https://github.com/greenbone/gsa";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "gsad";
    platforms = platforms.all;
  };
}
