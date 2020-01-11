{ stdenv, lib, fetchurl, dpkg, wrapGAppsHook
, gnome2, gtk3, atk, at-spi2-atk, cairo, pango, gdk-pixbuf, glib, freetype, fontconfig
, dbus, libX11, xorg, libXi, libXcursor, libXdamage, libXrandr, libXcomposite
, libXext, libXfixes, libXrender, libXtst, libXScrnSaver, nss, nspr, alsaLib
, cups, expat, udev, libnotify, libuuid, at-spi2-core, libappindicator-gtk3
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
  rpath = lib.makeLibraryPath [
    alsaLib
    atk
    at-spi2-atk
    at-spi2-core
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
    pango
    libappindicator-gtk3
    libnotify
    libuuid
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
    nspr
    nss
    udev
    xorg.libxcb
  ];

in stdenv.mkDerivation rec {
  pname = "signal-desktop";
  version = "1.29.3"; # Please backport all updates to the stable channel.
  # All releases have a limited lifetime and "expire" 90 days after the release.
  # When releases "expire" the application becomes unusable until an update is
  # applied. The expiration date for the current release can be extracted with:
  # $ grep -a "^{\"buildExpiration" "${signal-desktop}/libexec/resources/app.asar"
  # (Alternatively we could try to patch the asar archive, but that requires a
  # few additional steps and might not be the best idea.)

  src = fetchurl {
    url = "https://updates.signal.org/desktop/apt/pool/main/s/signal-desktop/signal-desktop_${version}_amd64.deb";
    sha256 = "1rkj6rwmwwvyd5041r96j1dxlfbmc6xsdrza43c0ykdrhfj73h11";
  };

  phases = [ "unpackPhase" "installPhase" ];

  nativeBuildInputs = [ dpkg wrapGAppsHook ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out
    cp -R opt $out

    mv ./usr/share $out/share
    mv $out/opt/Signal $out/libexec
    rmdir $out/opt

    chmod -R g-w $out

    # Patch signal
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath ${rpath}:$out/libexec $out/libexec/signal-desktop
    wrapProgram $out/libexec/signal-desktop \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --prefix LD_LIBRARY_PATH : "${stdenv.cc.cc.lib}/lib" \
      ${customLanguageWrapperArgs} \
      "''${gappsWrapperArgs[@]}"

    # Symlink to bin
    mkdir -p $out/bin
    ln -s $out/libexec/signal-desktop $out/bin/signal-desktop

    # Fix the desktop link
    substituteInPlace $out/share/applications/signal-desktop.desktop \
      --replace /opt/Signal/signal-desktop $out/bin/signal-desktop
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
