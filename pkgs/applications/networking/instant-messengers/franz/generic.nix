{ stdenv
, makeWrapper
, wrapGAppsHook
, autoPatchelfHook
, dpkg
, xorg
, atk
, glib
, pango
, gdk-pixbuf
, cairo
, freetype
, fontconfig
, gtk3
, gnome2
, dbus
, nss
, nspr
, alsaLib
, cups
, expat
, udev
, libnotify
, xdg_utils
}:

# Helper function for building a derivation for Franz and forks.

{ pname, name, version, src, meta }:
stdenv.mkDerivation {
  inherit pname version src meta;

  # Don't remove runtime deps.
  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper wrapGAppsHook dpkg ];
  buildInputs = (with xorg; [
    libXi
    libXcursor
    libXdamage
    libXrandr
    libXcomposite
    libXext
    libXfixes
    libXrender
    libX11
    libXtst
    libXScrnSaver
  ]) ++ [
    gtk3
    atk
    glib
    pango
    gdk-pixbuf
    cairo
    freetype
    fontconfig
    dbus
    gnome2.GConf
    nss
    nspr
    alsaLib
    cups
    expat
    stdenv.cc.cc
  ];
  runtimeDependencies = [ udev.lib libnotify ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
    ln -s $out/opt/${name}/${pname} $out/bin

    # Provide desktop item and icon.
    cp -r usr/share $out
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace /opt/${name}/${pname} ${pname}
  '';

  dontWrapGApps = true;

  postFixup = ''
    wrapProgram $out/opt/${name}/${pname} \
      --prefix PATH : ${xdg_utils}/bin \
      "''${gappsWrapperArgs[@]}"
  '';
}
