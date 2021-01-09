{ stdenv, lib, fetchurl, config, makeWrapper
, alsaLib
, at-spi2-atk
, atk
, cairo
, coreutils
, cups
, curl
, dbus
, dbus-glib
, fontconfig
, freetype
, gdk-pixbuf
, glib
, glibc
, gnome3
, gnugrep
, gnupg
, gnused
, gpgme
, gtk2
, gtk3
, kerberos
, libcanberra
, libGL
, libGLU
, libX11
, libxcb
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXinerama
, libXrender
, libXScrnSaver
, libXt
, nspr
, nss
, pango
, runtimeShell
, writeScript
, xidel
}:

# imports `version` and `sources`
with (import ./release_sources.nix);

let
  arch = if stdenv.hostPlatform.system == "i686-linux"
    then "linux-i686"
    else "linux-x86_64";

  isPrefixOf = prefix: string:
    builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source:
      (isPrefixOf source.locale locale) && source.arch == arch;

  systemLocale = config.i18n.defaultLocale or "en-US";

  defaultSource = lib.findFirst (sourceMatches "en-US") {} sources;

  source = lib.findFirst (sourceMatches systemLocale) defaultSource sources;

  name = "thunderbird-bin-${version}";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/${version}/${source.arch}/${source.locale}/thunderbird-${version}.tar.bz2";
    inherit (source) sha256;
  };

  phases = "unpackPhase installPhase";

  libPath = lib.makeLibraryPath
    [ stdenv.cc.cc
      alsaLib
      at-spi2-atk
      atk
      cairo
      cups
      curl
      dbus-glib
      dbus
      fontconfig
      freetype
      gdk-pixbuf
      glib
      glibc
      gtk2
      gtk3
      kerberos
      libX11
      libXScrnSaver
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXinerama
      libXrender
      libXt
      libxcb
      libcanberra
      libGLU libGL
      nspr
      nss
      pango
    ] + ":" + lib.makeSearchPathOutput "lib" "lib64" [
      stdenv.cc.cc
    ];

  buildInputs = [ gtk3 gnome3.adwaita-icon-theme ];

  nativeBuildInputs = [ makeWrapper ];

  # See "Note on GPG support" in `../thunderbird/default.nix` for explanations
  # on adding `gnupg` and `gpgme` into PATH/LD_LIBRARY_PATH.

  installPhase =
    ''
      mkdir -p "$prefix/usr/lib/thunderbird-bin-${version}"
      cp -r * "$prefix/usr/lib/thunderbird-bin-${version}"

      mkdir -p "$out/bin"
      ln -s "$prefix/usr/lib/thunderbird-bin-${version}/thunderbird" "$out/bin/"

      for executable in \
        thunderbird crashreporter thunderbird-bin plugin-container updater
      do
        patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          "$out/usr/lib/thunderbird-bin-${version}/$executable"
      done

      find . -executable -type f -exec \
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/thunderbird-bin-${version}/{}" \;

      # Create a desktop item.
      mkdir -p $out/share/applications
      cat > $out/share/applications/thunderbird.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Exec=$out/bin/thunderbird
      Icon=$out/usr/lib/thunderbird-bin-${version}/chrome/icons/default/default256.png
      Name=Thunderbird
      GenericName=Mail Reader
      Categories=Application;Network;
      EOF

      # SNAP_NAME: https://github.com/NixOS/nixpkgs/pull/61980
      # MOZ_LEGACY_PROFILES and MOZ_ALLOW_DOWNGRADE:
      #   commit 87e261843c4236c541ee0113988286f77d2fa1ee
      wrapProgram "$out/bin/thunderbird" \
        --argv0 "$out/bin/.thunderbird-wrapped" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:" \
        --suffix XDG_DATA_DIRS : "$XDG_ICON_DIRS" \
        --set SNAP_NAME "thunderbird" \
        --set MOZ_LEGACY_PROFILES 1 \
        --set MOZ_ALLOW_DOWNGRADE 1 \
        --prefix PATH : "${lib.getBin gnupg}/bin" \
        --prefix LD_LIBRARY_PATH : "${lib.getLib gpgme}/lib"
    '';

  passthru.updateScript = import ./../../browsers/firefox-bin/update.nix {
    inherit name writeScript xidel coreutils gnused gnugrep curl gnupg runtimeShell;
    baseName = "thunderbird";
    channel = "release";
    basePath = "pkgs/applications/networking/mailreaders/thunderbird-bin";
    baseUrl = "http://archive.mozilla.org/pub/thunderbird/releases/";
  };
  meta = with lib; {
    description = "Mozilla Thunderbird, a full-featured email client (binary package)";
    homepage = "http://www.mozilla.org/thunderbird/";
    license = {
      free = false;
      url = "http://www.mozilla.org/en-US/foundation/trademarks/policy/";
    };
    maintainers = with lib.maintainers; [ ];
    platforms = platforms.linux;
  };
}
