{ stdenv, fetchurl, config
, gconf
, alsaLib
, at_spi2_atk
, atk
, cairo
, cups
, curl
, dbus_glib
, dbus_libs
, fontconfig
, freetype
, gdk_pixbuf
, glib
, glibc
, gst_plugins_base
, gstreamer
, gtk2
, kerberos
, libX11
, libXScrnSaver
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
, mesa
, nspr
, nss
, pango
, writeScript
, xidel
, coreutils
, gnused
, gnugrep
}:

assert stdenv.isLinux;

# imports `version` and `sources`
with (import ./sources.nix);

let
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

in

stdenv.mkDerivation {
  name = "thunderbird-bin-${version}";

  src = fetchurl {
    url = "http://download-installer.cdn.mozilla.net/pub/thunderbird/releases/${version}/${source.arch}/${source.locale}/thunderbird-${version}.tar.bz2";
    inherit (source) sha512;
  };

  phases = "unpackPhase installPhase";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.cc
      gconf
      alsaLib
      at_spi2_atk
      atk
      cairo
      cups
      curl
      dbus_glib
      dbus_libs
      fontconfig
      freetype
      gdk_pixbuf
      glib
      glibc
      gst_plugins_base
      gstreamer
      gtk2
      kerberos
      libX11
      libXScrnSaver
      libXcomposite
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
    ] + ":" + stdenv.lib.makeSearchPathOutput "lib" "lib64" [
      stdenv.cc.cc
    ];

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
    '';

  passthru.updateScript =
    let
      version = (builtins.parseDrvName name).version;
    in
      writeScript "update-thunderbird-bin" ''
        PATH=${coreutils}/bin:${gnused}/bin:${gnugrep}/bin:${xidel}/bin:${curl}/bin

        pushd pkgs/applications/networking/mailreaders/thunderbird-bin/

        tmpfile=`mktemp`
        url=http://archive.mozilla.org/pub/thunderbird/releases/

        # retriving latest released version
        #  - extracts all links from the $url
        #  - removes . and ..
        #  - this line remove everything not starting with a number
        #  - this line sorts everything with semver in mind
        #  - this line removes beta version if we are looking for final release
        #    versions or removes release versions if we are looking for beta
        #    versions
        # - this line pick up latest release
        version=`xidel -q $url --extract "//a" | \
                 sed s"/.$//" | \
                 grep "^[0-9]" | \
                 sort --version-sort | \
                 grep -e "\([[:digit:]]\|[[:digit:]][[:digit:]]\)$" | \
                 grep -v "b" | \
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
                       grep "thunderbird-$version.tar.bz2$" | \
                       tr " " ":"`; do
            # create an entry for every locale
            cat >> $tmpfile <<EOF
            { locale = "`echo $line | cut -d":" -f3 | sed "s/$arch\///" | sed "s/\/.*//"`";
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

        mv $tmpfile sources.nix

        popd
      '';

  meta = with stdenv.lib; {
    description = "Mozilla Thunderbird, a full-featured email client (binary package)";
    homepage = http://www.mozilla.org/thunderbird/;
    license = {
      free = false;
      url = http://www.mozilla.org/en-US/foundation/trademarks/policy/;
    };
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = platforms.linux;
  };
}
