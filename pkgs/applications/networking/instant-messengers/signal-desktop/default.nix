{ stdenv, lib, fetchurl, autoPatchelfHook, dpkg, wrapGAppsHook
, gnome2, gtk3, atk, at-spi2-atk, cairo, pango, gdk-pixbuf, glib, freetype, fontconfig
, dbus, libX11, xorg, libXi, libXcursor, libXdamage, libXrandr, libXcomposite
, libXext, libXfixes, libXrender, libXtst, libXScrnSaver, nss, nspr, alsaLib
, cups, expat, systemd, libnotify, libuuid, at-spi2-core, libappindicator-gtk3
# Unfortunately this also overwrites the UI language (not just the spell
# checking language!):
, hunspellDicts, spellcheckerLanguage ? null # E.g. "de_DE"
# For a full list of available languages:
# $ cat pkgs/development/libraries/hunspell/dictionaries.nix | grep "dictFileName =" | awk '{ print $3 }'
}:

let
  customLanguageWrapperArgs = (with lib;
    let
      # E.g. "de_DE" -> "de-de" (spellcheckerLanguage -> hunspellDict)
      spellLangComponents = splitString "_" spellcheckerLanguage;
      hunspellDict = elemAt spellLangComponents 0 + "-" + toLower (elemAt spellLangComponents 1);
    in if spellcheckerLanguage != null
      then ''
        --set HUNSPELL_DICTIONARIES "${hunspellDicts.${hunspellDict}}/share/hunspell" \
        --set LC_MESSAGES "${spellcheckerLanguage}"''
      else "");
in stdenv.mkDerivation rec {
  pname = "signal-desktop";
  version = "1.31.0"; # Please backport all updates to the stable channel.
  # All releases have a limited lifetime and "expire" 90 days after the release.
  # When releases "expire" the application becomes unusable until an update is
  # applied. The expiration date for the current release can be extracted with:
  # $ grep -a "^{\"buildExpiration" "${signal-desktop}/lib/Signal/resources/app.asar"
  # (Alternatively we could try to patch the asar archive, but that requires a
  # few additional steps and might not be the best idea.)

  src = fetchurl {
    url = "https://updates.signal.org/desktop/apt/pool/main/s/signal-desktop/signal-desktop_${version}_amd64.deb";
    sha256 = "19vsv7jv30xvfgq1nr3091b6x4agymy9afpy9r9mxzgn0xfb0ap9";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook
  ];

  buildInputs = [
    alsaLib
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
    nspr
    nss
    pango
    systemd
    xorg.libxcb
  ];

  runtimeDependencies = [
    systemd.lib
  ];

  unpackPhase = "dpkg-deb -x $src .";

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  # We need to run autoPatchelf manually with the "no-recurse" option, see
  # https://github.com/NixOS/nixpkgs/pull/78413 for the reasons.
  dontAutoPatchelf = true;

  installPhase = ''
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
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ] }"
      ${customLanguageWrapperArgs}
    )

    # Fix the desktop link
    substituteInPlace $out/share/applications/signal-desktop.desktop \
      --replace /opt/Signal/signal-desktop $out/bin/signal-desktop

    autoPatchelf --no-recurse -- $out/lib/Signal/
  '';

  meta = {
    description = "Private, simple, and secure messenger";
    longDescription = ''
      Signal Desktop is an Electron application that links with your
      "Signal Android" or "Signal iOS" app.
    '';
    homepage    = https://signal.org/;
    license     = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ixmatus primeos equirosa ];
    platforms   = [ "x86_64-linux" ];
  };
}
