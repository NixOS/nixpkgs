{ stdenv, fetchurl, config, makeWrapper
, alsaLib
, atk
, cairo
, curl
, cups
, dbus_glib
, dbus_libs
, fontconfig
, freetype
, gconf
, gdk_pixbuf
, glib
, glibc
, gst_plugins_base
, gstreamer
, gtk2
, gtk3
, libX11
, libXScrnSaver
, libxcb
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXinerama
, libXrender
, libXt
, libcanberra_gtk2
, libgnome
, libgnomeui
, defaultIconTheme
, mesa
, nspr
, nss
, pango
, libheimdal
, libpulseaudio
, systemd
, generated ? import ./sources.nix
, writeScript
, xidel
, coreutils
, gnused
, gnugrep
}:

assert stdenv.isLinux;

let

  inherit (generated) version sources;

  arch = if stdenv.system == "i686-linux"
    then "linux-i686"
    else "linux-x86_64";

  isPrefixOf = prefix: string:
    builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source:
      (isPrefixOf source.locale locale) && source.arch == arch;

  systemLocale = config.i18n.defaultLocale or "en-US";

  defaultSource = stdenv.lib.findFirst (sourceMatches "en-US") {} sources;

  source = stdenv.lib.findFirst (sourceMatches systemLocale) defaultSource sources;

  name = "firefox-bin-unwrapped-${version}";

in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl { inherit (source) url sha512; };

  phases = "unpackPhase installPhase";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.cc
      alsaLib
      atk
      cairo
      curl
      cups
      dbus_glib
      dbus_libs
      fontconfig
      freetype
      gconf
      gdk_pixbuf
      glib
      glibc
      gst_plugins_base
      gstreamer
      gtk2
      gtk3
      libX11
      libXScrnSaver
      libXcomposite
      libxcb
      libXdamage
      libXext
      libXfixes
      libXinerama
      libXrender
      libXt
      libcanberra_gtk2
      libgnome
      libgnomeui
      mesa
      nspr
      nss
      pango
      libheimdal
      libpulseaudio
      libpulseaudio.dev
      systemd
    ] + ":" + stdenv.lib.makeSearchPathOutput "lib" "lib64" [
      stdenv.cc.cc
    ];

  buildInputs = [ makeWrapper gtk3 defaultIconTheme ];

  # "strip" after "patchelf" may break binaries.
  # See: https://github.com/NixOS/patchelf/issues/10
  dontStrip = 1;

  installPhase =
    ''
      mkdir -p "$prefix/usr/lib/firefox-bin-${version}"
      cp -r * "$prefix/usr/lib/firefox-bin-${version}"

      mkdir -p "$out/bin"
      ln -s "$prefix/usr/lib/firefox-bin-${version}/firefox" "$out/bin/"

      for executable in \
        firefox firefox-bin plugin-container \
        updater crashreporter webapprt-stub
      do
        if [ -e "$out/usr/lib/firefox-bin-${version}/$executable" ]; then
          patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            "$out/usr/lib/firefox-bin-${version}/$executable"
        fi
      done

      find . -executable -type f -exec \
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/firefox-bin-${version}/{}" \;

      # wrapFirefox expects "$out/lib" instead of "$out/usr/lib"
      ln -s "$out/usr/lib" "$out/lib"

      # Create a desktop item.
      mkdir -p $out/share/applications
      cat > $out/share/applications/firefox.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Exec=$out/bin/firefox
      Icon=$out/usr/lib/firefox-bin-${version}/browser/icons/mozicon128.png
      Name=Firefox
      GenericName=Web Browser
      Categories=Application;Network;
      EOF

      wrapProgram "$out/bin/firefox" \
        --argv0 "$out/bin/.firefox-wrapped" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:" \
        --suffix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    '';

  passthru.ffmpegSupport = true;
  passthru.updateScript =
    let
      version = (builtins.parseDrvName name).version;
      isBeta = builtins.stringLength version + 1 == builtins.stringLength (builtins.replaceStrings ["b"] ["bb"] version);
    in
      writeScript "update-firefox-bin" ''
        PATH=${coreutils}/bin:${gnused}/bin:${gnugrep}/bin:${xidel}/bin:${curl}/bin

        pushd pkgs/applications/networking/browsers/firefox-bin

        tmpfile=`mktemp`
        url=http://archive.mozilla.org/pub/firefox/releases/

        # retriving latest released version
        #  - extracts all links from the $url
        #  - removes . and ..
        #  - this line remove everything not starting with a number
        #  - this line sorts everything with semver in mind
        #  - we remove lines that are mentioning funnelcake
        #  - this line removes beta version if we are looking for final release
        #    versions or removes release versions if we are looking for beta
        #    versions
        # - this line pick up latest release
        version=`xidel -q $url --extract "//a" | \
                 sed s"/.$//" | \
                 grep "^[0-9]" | \
                 sort --version-sort | \
                 grep -v "funnelcake" | \
                 grep -e "${if isBeta then "b" else ""}\([[:digit:]]\|[[:digit:]][[:digit:]]\)$" | ${if isBeta then "" else "grep -v \"b\" |"} \
                 tail -1`

        # this is a list of sha512 and tarballs for both arches
        shasums=`curl --silent $url$version/SHA512SUMS`

        cat > $tmpfile <<EOF
        {
          version = "$version";
          sources = [
        EOF
        for arch in linux-x86_64 linux-i686; do
          # retriving a list of all tarballs for each arch
          #  - only select tarballs for current arch
          #  - only select tarballs for current version
          #  - rename space with colon so that for loop doesnt
          #  - inteprets sha and path as 2 lines
          for line in `echo "$shasums" | \
                       grep $arch | \
                       grep "firefox-$version.tar.bz2$" | \
                       tr " " ":"`; do
            # create an entry for every locale
            cat >> $tmpfile <<EOF
            { url = "$url$version/`echo $line | cut -d":" -f3`";
              locale = "`echo $line | cut -d":" -f3 | sed "s/$arch\///" | sed "s/\/.*//"`";
              arch = "$arch";
              sha512 = "`echo $line | cut -d":" -f1`";
            }
        EOF
          done
        done
        cat >> $tmpfile <<EOF
            ];
        }
        EOF

        mv $tmpfile ${if isBeta then "beta_" else ""}sources.nix

        popd
      '';

  meta = with stdenv.lib; {
    description = "Mozilla Firefox, free web browser (binary package)";
    homepage = http://www.mozilla.org/firefox/;
    license = {
      free = false;
      url = http://www.mozilla.org/en-US/foundation/trademarks/policy/;
    };
    platforms = platforms.linux;
    maintainers = with maintainers; [ garbas ];
  };
}
