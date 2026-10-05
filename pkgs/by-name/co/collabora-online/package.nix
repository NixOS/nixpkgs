{
  autoreconfHook,
  cairo,
  cppunit,
  fetchFromGitHub,
  fetchpatch,
  fetchNpmDeps,
  lib,
  libcap,
  libpng,
  libreoffice-collabora,
  nodejs,
  npmHooks,
  pam,
  pango,
  pixman,
  pkg-config,
  poco,
  python3,
  rsync,
  stdenv,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "collabora-online";
  version = "25.04.12-4";

  src = fetchFromGitHub {
    owner = "CollaboraOnline";
    repo = "online.mirror";
    tag = "cp-${finalAttrs.version}";
    hash = "sha256-wllEcYt4gN9knUuQP64Rnt3allZOnC7xdaQsJXS2OtU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    python3
    python3.pkgs.lxml
    python3.pkgs.polib
    rsync
  ];

  buildInputs = [
    cairo
    cppunit
    libcap
    libpng
    pam
    pango
    pixman
    poco
    zstd
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-setcap"
    "--disable-werror"
    "--enable-silent-rules"
    "--with-lo-path=${libreoffice-collabora}/lib/collaboraoffice"
    "--with-lokit-path=${libreoffice-collabora.src}/include"
  ];

  patches = [
    ./fix-file-server-regex.patch
  ];

  postPatch = ''
    cp ${./package-lock.json} ${finalAttrs.npmRoot}/package-lock.json

    patchShebangs browser/util/*.py coolwsd-systemplate-setup scripts/*
    substituteInPlace configure.ac --replace-fail '/usr/bin/env python3' python3
  '';

  # Copy dummy self-signed certificates provided for testing.
  postInstall = ''
    cp etc/ca-chain.cert.pem etc/cert.pem etc/key.pem $out/etc/coolwsd
  '';

  npmDeps = fetchNpmDeps {
    unpackPhase = "true";
    # TODO: Use upstream `npm-shrinkwrap.json` once it's fixed
    # https://github.com/CollaboraOnline/online/issues/9644
    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';
    hash = "sha256-7lOmv5NOYCf9lF9+To+ha9oIgbX3haTd/zo1iArQBBs=";
  };

  npmRoot = "browser";

  passthru = {
    libreoffice = libreoffice-collabora; # Used by NixOS module.
  };

  meta = {
    description = "Collaborative online office suite based on LibreOffice technology";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.xzfc ];
    homepage = "https://www.collaboraonline.com";
    platforms = lib.platforms.linux;
  };
})
