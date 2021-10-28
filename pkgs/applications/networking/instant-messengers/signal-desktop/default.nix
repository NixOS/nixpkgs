{ stdenv, lib, fetchurl, autoPatchelfHook, dpkg, wrapGAppsHook, nixosTests
, gnome2, gtk3, atk, at-spi2-atk, cairo, pango, gdk-pixbuf, glib, freetype, fontconfig
, dbus, libX11, xorg, libXi, libXcursor, libXdamage, libXrandr, libXcomposite
, libXext, libXfixes, libXrender, libXtst, libXScrnSaver, nss, nspr, alsa-lib
, cups, expat, libuuid, at-spi2-core, libappindicator-gtk3, mesa
# Runtime dependencies:
, systemd, libnotify, libdbusmenu, libpulseaudio
# Unfortunately this also overwrites the UI language (not just the spell
# checking language!):
, hunspellDicts, spellcheckerLanguage ? null # E.g. "de_DE"
# For a full list of available languages:
# $ cat pkgs/development/libraries/hunspell/dictionaries.nix | grep "dictFileName =" | awk '{ print $3 }'
, sqlcipher
}:

let
  customLanguageWrapperArgs = (with lib;
    let
      # E.g. "de_DE" -> "de-de" (spellcheckerLanguage -> hunspellDict)
      spellLangComponents = splitString "_" spellcheckerLanguage;
      hunspellDict = elemAt spellLangComponents 0 + "-" + toLower (elemAt spellLangComponents 1);
    in lib.optionalString (spellcheckerLanguage != null) ''
      --set HUNSPELL_DICTIONARIES "${hunspellDicts.${hunspellDict}}/share/hunspell" \
      --set LC_MESSAGES "${spellcheckerLanguage}"'');

  sqlcipher-signal = sqlcipher.overrideAttrs (_: {
    # Using the same features as the upstream signal sqlcipher build
    # https://github.com/signalapp/better-sqlite3/blob/2fa02d2484e9f9a10df5ac7ea4617fb2dff30006/deps/defines.gypi
    CFLAGS = [
      "-DSQLITE_LIKE_DOESNT_MATCH_BLOBS"
      "-DSQLITE_THREADSAFE=2"
      "-DSQLITE_USE_URI=0"
      "-DSQLITE_DEFAULT_MEMSTATUS=0"
      "-DSQLITE_OMIT_DEPRECATED"
      "-DSQLITE_OMIT_GET_TABLE"
      "-DSQLITE_OMIT_TCL_VARIABLE"
      "-DSQLITE_OMIT_PROGRESS_CALLBACK"
      "-DSQLITE_OMIT_SHARED_CACHE"
      "-DSQLITE_TRACE_SIZE_LIMIT=32"
      "-DSQLITE_DEFAULT_CACHE_SIZE=-16000"
      "-DSQLITE_DEFAULT_FOREIGN_KEYS=1"
      "-DSQLITE_DEFAULT_WAL_SYNCHRONOUS=1"
      "-DSQLITE_ENABLE_COLUMN_METADATA"
      "-DSQLITE_ENABLE_UPDATE_DELETE_LIMIT"
      "-DSQLITE_ENABLE_STAT4"
      "-DSQLITE_ENABLE_FTS5"
      "-DSQLITE_ENABLE_JSON1"
      "-DSQLITE_ENABLE_RTREE"
      "-DSQLITE_INTROSPECTION_PRAGMAS"

      # SQLCipher-specific options
      "-DSQLITE_HAS_CODEC"
      "-DSQLITE_TEMP_STORE=2"
      "-DSQLITE_SECURE_DELETE"
    ];

    LDFLAGS = [ "-lm" ];
  });
in stdenv.mkDerivation rec {
  pname = "signal-desktop";
  version = "5.22.0"; # Please backport all updates to the stable channel.
  # All releases have a limited lifetime and "expire" 90 days after the release.
  # When releases "expire" the application becomes unusable until an update is
  # applied. The expiration date for the current release can be extracted with:
  # $ grep -a "^{\"buildExpiration" "${signal-desktop}/lib/Signal/resources/app.asar"
  # (Alternatively we could try to patch the asar archive, but that requires a
  # few additional steps and might not be the best idea.)

  src = fetchurl {
    url = "https://updates.signal.org/desktop/apt/pool/main/s/signal-desktop/signal-desktop_${version}_amd64.deb";
    sha256 = "1y88qw57wk187fjb05zqvagv4pamc8171xwvznqb2k0vclsg82j8";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libappindicator-gtk3
    libnotify
    libuuid
    mesa # for libgbm
    nspr
    nss
    pango
    systemd
    xorg.libxcb
    xorg.libxshmfence
  ];

  runtimeDependencies = [
    (lib.getLib systemd)
    libnotify
    libdbusmenu
  ];

  unpackPhase = "dpkg-deb -x $src .";

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  # We need to run autoPatchelf manually with the "no-recurse" option, see
  # https://github.com/NixOS/nixpkgs/pull/78413 for the reasons.
  dontAutoPatchelf = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib

    mv usr/share $out/share
    mv opt/Signal $out/lib/Signal

    # Note: The following path contains bundled libraries:
    # $out/lib/Signal/resources/app.asar.unpacked/node_modules/sharp/vendor/lib/
    # We run autoPatchelf with the "no-recurse" option to avoid picking those
    # up, but resources/app.asar still requires them.

    # Symlink to bin
    mkdir -p $out/bin
    ln -s $out/lib/Signal/signal-desktop $out/bin/signal-desktop

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ] }"
      --prefix LD_PRELOAD : "${sqlcipher-signal}/lib/libsqlcipher.so"
      ${customLanguageWrapperArgs}
    )

    # Fix the desktop link
    substituteInPlace $out/share/applications/signal-desktop.desktop \
      --replace /opt/Signal/signal-desktop $out/bin/signal-desktop

    autoPatchelf --no-recurse -- $out/lib/Signal/
    patchelf --add-needed ${libpulseaudio}/lib/libpulse.so $out/lib/Signal/resources/app.asar.unpacked/node_modules/ringrtc/build/linux/libringrtc-x64.node
  '';

  # Tests if the application launches and waits for "Link your phone to Signal Desktop":
  passthru.tests.application-launch = nixosTests.signal-desktop;

  meta = {
    description = "Private, simple, and secure messenger";
    longDescription = ''
      Signal Desktop is an Electron application that links with your
      "Signal Android" or "Signal iOS" app.
    '';
    homepage    = "https://signal.org/";
    changelog   = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${version}";
    license     = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ixmatus primeos equirosa ];
    platforms   = [ "x86_64-linux" ];
  };
}
