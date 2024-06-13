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
    "-DSYSCONFDIR=etc"
  ];

  configurePhase = ''
    cd $out/gsad
    cmake -S $out/gsad -B ..
  '';

  preInstall = ''
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
      $out/run/gvmd \
      $out/run/gsad/gsad.pid
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
