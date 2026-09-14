{
  autoreconfHook,
  cairo,
  cppunit,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchzip,
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
  kdePackages,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "collabora-desktop";
  version = "26.04.2.4-3";
  src = fetchFromGitHub {
    owner = "CollaboraOnline";
    repo = "online.mirror";
    rev = "coda-${finalAttrs.version}";
    hash = "sha256-PbtFJnA51rogdmqXgTwOn/FXDcUJ1FhhhNkNDf+CtiE=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    # permissions fix for templates
    ./0001-template-copy-permissions-fix.patch
  ];

  postPatch = ''
    cp ${./package-lock.json} ${finalAttrs.env.npmRoot}/package-lock.json

    patchShebangs browser/util/*.py coolwsd-systemplate-setup scripts/*
    substituteInPlace configure.ac --replace-fail '/usr/bin/env python3' python3

    # In Nixpkgs, lrelease and lupdate are provided by qttools, not qtbase.
    # So they won't be found in qtpaths6's QT_BIN_DIR.
    substituteInPlace configure.ac \
      --replace-fail 'test -n "$QT_BIN_DIR" -a -x "$QT_BIN_DIR/lrelease"' 'command -v lrelease >/dev/null' \
      --replace-fail 'LRELEASE="$QT_BIN_DIR/lrelease"' 'LRELEASE="lrelease"' \
      --replace-fail 'test -n "$QT_BIN_DIR" -a -x "$QT_BIN_DIR/lupdate"' 'command -v lupdate >/dev/null' \
      --replace-fail 'LUPDATE="$QT_BIN_DIR/lupdate"' 'LUPDATE="lupdate"'

    # Fix tsc-strict not finding tsc
    substituteInPlace browser/Makefile.am \
      --replace-warn '$(NODE) $(builddir)/node_modules/.bin/tsc-strict' 'PATH="$(abs_builddir)/node_modules/.bin:$$PATH" $(NODE) $(builddir)/node_modules/.bin/tsc-strict' \
      --replace-warn 'ci --offline' 'ci --offline && sed -i --follow-symlinks "s|^#!/usr/bin/env node|#!${nodejs}/bin/node|" node_modules/.bin/*'

    # workaround for QtWebEngine crash when loading 'cell' cursor
    substituteInPlace browser/css/spreadsheet.css \
      --replace-warn "cursor: cell" "cursor: crosshair"
  '';

  nativeBuildInputs = [
    autoreconfHook
    kdePackages.qttools
    perl
    nodejs
    pkg-config
    python3
    python3.pkgs.lxml
    python3.pkgs.polib
    rsync

    # from CollaboraOnline/nix-build-support
    (stdenv.mkDerivation {
      name = "qtlibexec";
      src = kdePackages.qtbase;
      buildPhase = ''
        mkdir -p $out
        ln -s ${kdePackages.qtbase}/libexec $out/bin
      '';
    })
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtwebengine

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
    "--with-lokit-path=${finalAttrs.passthru.libreoffice.src}/engine/include"
    "--enable-silent-rules"
    "--disable-ssl"
    "--with-info-url=https://collaboraoffice.com/"
  ];

  preBuild = ''
    export npm_config_cache=$(mktemp -d)
    cp -R ${finalAttrs.env.npmDeps}/. $npm_config_cache/
    chmod -R +w $npm_config_cache
  '';

  enableParallelBuilding = true;

  postInstall = ''
    cp --no-preserve=mode ${finalAttrs.passthru.libreoffice}/lib/collaboraoffice/LICENSE.html $out/LICENSE.html
    python3 scripts/insert-coda-license.py $out/LICENSE.html CODA-THIRDPARTYLICENSES.html

    # Apply official branding
    cp -a ${finalAttrs.env.brandSrc}/branding* ${finalAttrs.env.brandSrc}/images ${finalAttrs.env.brandSrc}/welcome $out/share/coolwsd/browser/dist/
  '';

  env = {
    brandSrc = fetchzip {
      url = "https://www.collaboraoffice.com/downloads/collabora-office-brand/collabora-office-brand-26.04.2.3.tar.gz";
      hash = "sha256-z5nVEhMMBkDpYTF/X24HJj28HvwXjzC7PEIhm7NeAU0=";
      stripRoot = true;
    };

    npmDeps = fetchNpmDeps {
      unpackPhase = "true";
      # TODO: Use upstream `npm-shrinkwrap.json` once it's fixed
      # https://github.com/CollaboraOnline/online/issues/9644
      postPatch = ''
        cp ${./package-lock.json} package-lock.json
      '';
      hash = "sha256-yQYS/Cm3mq20RDBQGSdpnp+OKdttBul2+95WqH+6W4k=";
    };

    npmRoot = "browser";
  };

  passthru = {
    libreoffice = libreoffice-collabora.override {
      variant = "collabora-coda";
      withFonts = true;
      withJava = false;
    };

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
