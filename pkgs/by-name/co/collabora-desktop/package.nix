{
  autoreconfHook,
  cairo,
  cppunit,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  libcap,
  libpng,
  libreoffice-collabora-coda,
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
  kdePackages,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "collabora-desktop";
  version = "25.04.8.1-1";
  src = fetchFromGitHub {
    owner = "CollaboraOnline";
    repo = "online";
    tag = "coda-${finalAttrs.version}";
    hash = "sha256-CwafnJiGjOnzA0yMIXlJU/jYnZlZFw0ulK76nZWWmhw=";
  };

  patches = [
    # permissions fix for templates
    ./0001-template-copy-permissions-fix.patch
  ];

  postPatch = ''
    cp ${./package-lock.json} ${finalAttrs.npmRoot}/package-lock.json

    patchShebangs browser/util/*.py coolwsd-systemplate-setup scripts/*
    substituteInPlace configure.ac --replace-fail '/usr/bin/env python3' python3
  '';

  nativeBuildInputs = [
    autoreconfHook
    perl
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    python3
    python3.pkgs.lxml
    python3.pkgs.polib
    rsync
    # from CollaboraOnline/nix-build-support
    kdePackages.qtbase.dev
    kdePackages.qttools
    (stdenv.mkDerivation {
      name = "qtlibexec";
      src = kdePackages.qtbase;
      buildPhase = ''
        mkdir -p $out
        ln -s ${kdePackages.qtbase}/libexec $out/bin
      '';
    })
    kdePackages.qtbase
    kdePackages.qtwebengine
    kdePackages.wrapQtAppsHook
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

  # handle flags with spaces safely
  preConfigure = ''
    configureFlagsArray+=(
      "--with-vendor=Collabora Productivity Limited"
      "--with-app-name=Collabora Office"
    )
  '';

  configureFlags = [
    "--enable-qtapp"
    "--disable-werror"
    "--enable-silent-rules"
    "--with-lo-path=${finalAttrs.passthru.libreoffice}/lib/collaboraoffice"
    "--with-lokit-path=${finalAttrs.passthru.libreoffice.src}/include"
    "--enable-silent-rules"
    "--disable-ssl"
    "--with-info-url=https://collaboraoffice.com/"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    cp --no-preserve=mode ${finalAttrs.passthru.libreoffice}/lib/collaboraoffice/LICENSE.html $out/LICENSE.html
    python3 scripts/insert-coda-license.py $out/LICENSE.html CODA-THIRDPARTYLICENSES.html
  '';

  npmDeps = fetchNpmDeps {
    unpackPhase = "true";
    # TODO: Use upstream `npm-shrinkwrap.json` once it's fixed
    # https://github.com/CollaboraOnline/online/issues/9644
    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';
    hash = "sha256-Vdd1sMDjraJSVP+SzItp6X0PbH6Z+iHdX5N70hYVSrk=";
  };

  npmRoot = "browser";

  passthru = {
    libreoffice = libreoffice-collabora-coda;
    updateScript = ./update.sh;
  };

  meta = {
    changelog = "https://www.collaboraonline.com/blog/";
    description = "Collaborative Office for desktop, based on LibreOffice technology";
    homepage = "https://www.collaboraonline.com/collabora-office/";
    license = lib.licenses.mpl20;
    mainProgram = "coda-qt";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.ngi ];
  };
})
