# based on https://github.com/nix-community/talon-nix

{ stdenv
, lib
, curl
, cacert
, requireFile
, makeWrapper
, dbus
, fontconfig
, freetype
, glib
, libGL
, libxkbcommon_7
, sqlite
, udev
, xorg
, zlib
, fetchurl
, libpulseaudio
, bzip2
, ncurses5
, gdk-pixbuf
, libuuid
, libdrm
, gtk3-x11
, cairo
, gdbm
, gnome2
, atk
, wayland
, wayland-protocols
, wlroots
, xwayland
, libinput
, libxml2
, speechd
}:

let
  inherit (lib.importJSON ./src.json) version sha256 url mirrorUrls contentLength lastModified;
in

stdenv.mkDerivation rec {
  pname = "talon-bin";
  inherit version;

  # the original url is mutable.
  # when the original url changed, fallback to mirror urls.
  #src = fetchurl { inherit url sha256; }; # this would fail with the original url
  src = stdenv.mkDerivation {
    name = builtins.baseNameOf url;
    outputHashMode = "flat";
    outputHashAlgo = "sha256";
    outputHash = sha256;
    inherit url mirrorUrls contentLength lastModified;
    phases = "buildPhase";
    nativeBuildInputs = [
      curl
      cacert
    ];
    # test: force download from mirror
    #contentLength=$((contentLength - 1))
    #lastModified="''${lastModified}-old"
    buildPhase = ''
      echo "fetching headers from original url $url ..."
      headers=$(curl -L -I $url)
      echo "headers:"
      echo "$headers"
      # note: -1 to remove trailing \r
      contentLengthActual=$(echo "$headers" | grep "^Content-Length:" | tail -n1)
      contentLengthActual=''${contentLengthActual:16: -1}
      lastModifiedActual=$(echo "$headers" | grep "^Last-Modified:" | tail -n1)
      lastModifiedActual=''${lastModifiedActual:15: -1}

      if [[ "$contentLengthActual" == "$contentLength" && "$lastModifiedActual" == "$lastModified" ]]
      then
        echo "fetching file from original url $url ..."
        curl -L -o $out $url
      else
        echo "note: original url has changed:"
        if [[ "$contentLengthActual" != "$contentLength" ]]; then
          echo "-Content-Length: $contentLength"
          echo "+Content-Length: $contentLengthActual"
        fi
        if [[ "$lastModifiedActual" != "$lastModified" ]]; then
          echo "-Last-Modified: $lastModified"
          echo "+Last-Modified: $lastModifiedActual"
        fi
        for url in "''${mirrorUrls[@]}"; do
          echo "fetching file from mirror $url ..."
          curl -L -o temp $url # TODO keep time?
          stat temp # debug
          contentLengthActual=$(stat -c%s temp)
          if [[ "$contentLengthActual" == "$contentLength" ]]; then
            mv temp $out
            break
          else
            echo "note: mirror url has changed:"
            echo "-Content-Length: $contentLength"
            echo "+Content-Length: $contentLengthActual"
          fi
        done
      fi
    '';
  };

  preferLocalBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc
    stdenv.cc.libc
    dbus
    fontconfig
    freetype
    glib
    libGL
    libxkbcommon_7
    sqlite
    zlib
    libpulseaudio
    udev
    xorg.libX11
    xorg.libSM
    xorg.libXcursor
    xorg.libICE
    xorg.libXrender
    xorg.libxcb
    xorg.libXext
    xorg.libXcomposite
    bzip2
    ncurses5
    libuuid
    gtk3-x11
    gdk-pixbuf
    cairo
    libdrm
    gnome2.pango
    gdbm
    atk
    wayland
    wayland-protocols
    wlroots
    xwayland
    libinput
    libxml2
    speechd
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase =
    let
      libPath = lib.makeLibraryPath buildInputs;
    in
    ''
      runHook preInstall

      # Copy Talon to the Nix store
      mkdir -p "$out"
      mkdir "$out/bin"
      mkdir -p "$out/etc/udev/rules.d"

      mkdir -p $out/share/applications

      cat << EOF > $out/share/applications/talon.desktop
        [Desktop Entry]
        Categories=Utility;
        Exec=talon
        Name=Talon
        Terminal=false
        Type=Application
      EOF

      cp 10-talon.rules $out/etc/udev/rules.d
      # Remove udev compatibility hack using plugdev for older debian/ubuntu
      # This breaks NixOS usage of these rules (see https://github.com/NixOS/nixpkgs/issues/76482)
      substituteInPlace $out/etc/udev/rules.d/10-talon.rules --replace 'GROUP="plugdev",' ""

      cp -r lib $out/lib
      cp talon $out/bin
      cp -r resources $out/bin/resources

      # Tell talon where to find glibc
      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/bin/talon

      # Replicate 'run.sh' and add library path
      wrapProgram "$out/bin/talon" \
        --unset QT_AUTO_SCREEN_SCALE_FACTOR \
        --unset QT_SCALE_FACTOR \
        --set   LC_NUMERIC C \
        --set   QT_PLUGIN_PATH "$out/lib/plugins" \
        --set   LD_LIBRARY_PATH "$out/bin/resources/python/lib/python3.9/site-packages/numpy.libs:$out/lib:$out/bin/resources/python/lib:$out/bin/resources/pypy/lib:${libPath}" \
        --set   QT_DEBUG_PLUGINS 1

      # This will fix the talon repl
      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/bin/resources/python/bin/python3
      wrapProgram "$out/bin/resources/python/bin/python3" \
        --set LD_LIBRARY_PATH ${libPath}

      # The libbz2 derivation in Nix doesn't provide the right .so filename, so
      # we fake it by adding a link in the lib/ directory
      (
        cd "$out/lib"
        ln -s ${bzip2.out}/lib/libbz2.so.1 libbz2.so.1.0
        ln -s ${gdbm}/lib/libgdbm.so libgdbm.so.5
      )

      runHook postInstall
    '';

  meta = {
    homepage = "https://talonvoice.com/";
    description = "Voice coding application";
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
