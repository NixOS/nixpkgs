{ stdenv, fetchurl, system, rsync, makeWrapper,
  alsaLib, dbus, glib, gstreamer, fontconfig, freetype, libpulseaudio, libxml2,
  libxslt, mesa, nspr, nss, sqlite, utillinux, zlib, xorg }:

let

  version = "2.0.91373.0502";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
      sha256 = "0gcbfsvybkvnyklm82irgz19x3jl0hz9bwf2l9jga188057pfj7a";
    };
  };

in stdenv.mkDerivation {
  name = "zoom-us-${version}";

  src = srcs.${system};

  buildInputs = [ rsync makeWrapper ];

  libPath = stdenv.lib.makeLibraryPath [
    alsaLib
    dbus
    glib
    gstreamer
    fontconfig
    freetype
    libpulseaudio
    libxml2
    libxslt
    mesa
    nspr
    nss
    sqlite
    utillinux
    zlib

    xorg.libX11
    xorg.libSM
    xorg.libICE
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.libXcursor
    xorg.libXext
    xorg.libXfixes
    xorg.libXdamage
    xorg.libXtst
    xorg.libxshmfence
    xorg.libXi
    xorg.libXrender
    xorg.libXcomposite

    stdenv.cc.cc
  ];

  installPhase = ''
    $preInstallHooks

    mkdir -p $out/share
    mkdir -p $out/bin
    rsync -av . $out/share/

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/share/zoom
    # included from https://github.com/NixOS/nixpkgs/commit/fc218766333a05c9352b386e0cbb16e1ae84bf53
    # it works for me without it, but, well...
    paxmark m $out/share/zoom
    #paxmark m $out/share/QtWebEngineProcess # is this what dtzWill talked about?

    # RUNPATH set via patchelf is used only for half of libraries (why?), so wrap it
    wrapProgram $out/share/zoom \
        --prefix LD_LIBRARY_PATH : "$out/share:$libPath" \
        --set QT_PLUGIN_PATH "$out/share/platforms" \
        --set QT_XKB_CONFIG_ROOT "${xorg.xkeyboardconfig}/share/X11/xkb" \
        --set QTCOMPOSE "${xorg.libX11.out}/share/X11/locale"
    ln -s "$out/share/zoom" "$out/bin/zoom"

    $postInstallHooks
  '';

  meta = {
    homepage = http://zoom.us;
    description = "zoom.us video conferencing application";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ danbst ];
  };

}
