{
  cmake,
  doxygen,
  fetchFromGitHub,
  gettext,
  git,
  glib,
  gnutar,
  gnutls,
  gvm-libs,
  lib,
  libidn2,
  libgcrypt,
  libmicrohttpd,
  libselinux,
  libsepol,
  libtasn1,
  libxml2,
  libxslt,
  p11-kit,
  pcre2,
  pkg-config,
  python3Packages,
  stdenv,
  util-linux,
  xmltoman,
}:

stdenv.mkDerivation rec {
  pname = "gsad";
  version = "22.10.0";

  # web app needed to start web server
  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "gsa";
    rev = "refs/tags/v23.1.1";
    hash = "sha256-yA+B6fh8C07tGEoy/+FPvcvx3D1OfPig0Eoqv2oJfsA=";
  };

  # web server
  src2 = fetchFromGitHub {
    owner = "greenbone";
    repo = "gsad";
    rev = "refs/tags/v${version}";
    hash = "sha256-/Ew1o/2Xve1VN8BlR8n+IaEfY8ecs9vBe5Cdx2ttZIo=";
  };

  unpackPhase = ''
    runHook preUnpack

    mkdir -p $out/share/gvm/gsad/web
    mkdir -p $out/{gsad,build}
    cp -R $src/* $out/share/gvm/gsad/web
    cp -R $src2/* $out/gsad

    runHook postUnpack
  '';

  preConfigure = ''
    mkdir -p \
      $out{bin,sbin,lib,include,share} \
      $out/var/lib/gvm/{openvas/plugins,cert-data,users,scap-data,CA,data-objects,private/CA} \
      $out/var/log \
      $out/run/{gvmd,gsad} \
      $out/share/gvm/gsad
      #installManPage $src2/doc/gsad.8
  '';

  configurePhase = ''
    runHook preConfigure

    cd $out/build
    cmake -S $out/gsad \
      -DBINDIR=$out/bin \
      -DSBINDIR=$out/sbin \
      -DLIBDIR=$out/lib \
      -DLOCALSTATEDIR=$out/var \
      -DINCLUDEDIR=$out/include \
      -DDATADIR=$out/share \
      -DCMAKE_BUILD_TYPE=Release \
      -DSYSCONFDIR=$out/etc \
      -DGSAD_CONFIG_DIR=$out/etc \
      -DGVMD_RUN_DIR=$out/run/gvmd \
      -DGSAD_RUN_DIR=$out/run/gsad \
      -DLOGROTATE_DIR=$out/etc/logrotate.d \
      -DGSAD_DATA_DIR=$out/share/gvm/gsad \
      -DGSAD_CONFIG_DIR=$out/etc/gsad \
      -DGVMD_RUN_DIR=$out/run/gvmd \
      -DGVM_STATE_DIR=$out/var/lib/gvm \
      -DGVM_LOG_DIR=$out/var/log/gvm \
      -DGVM_SERVER_CERTIFICATE=$out/var/lib/gvm/CA/servercert.pem \
      -DGVM_SERVER_KEY=$out/var/lib/gvm/private/CA/serverkey.pem \
      -DGVM_CA_CERTIFICATE=$out/var/lib/gvm/CA/cacert.pem \
      -DGSAD_LOCALE_DIR=$out/share/locale \
      -DGSAD_CHROOT_LOCALE_DIR=$out/share/locale \
      -DSYSTEMD_SERVICE_DIR=$out/lib/systemd/system \
      -DLOGROTATE_DIR=$out/etc/ \
    -B .

    runHook postConfigure
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    git
    pkg-config
    xmltoman
  ];

  buildInputs = [
    gettext
    glib
    gnutar
    gnutls
    gvm-libs
    libgcrypt
    libidn2
    libmicrohttpd
    libselinux
    libsepol
    libtasn1
    libxml2
    libxslt
    p11-kit
    pcre2
    python3Packages.polib
    util-linux
  ];

  preFixup = ''
    rm -rf $out/build
    rm -rf $out/gsad
  '';

  meta = {
    description = "Greenbone Security Assistant - The web frontend and web server for the Greenbone Community Edition";
    homepage = "https://github.com/greenbone/gsa";
    changelog = "https://github.com/greenbone/gsa/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "gsad";
    platforms = lib.platforms.all;
  };
}
