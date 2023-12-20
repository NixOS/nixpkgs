{ stdenv
, lib
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
, dbus
, nss
, nspr
, alsa-lib
, cups
, expat
, udev
, libnotify
, xdg-utils
, mesa
, libglvnd
, libappindicator-gtk3
}:

# Helper function for building a derivation for Franz and forks.

{ pname, name, version, src, meta, extraBuildInputs ? [], ... } @ args:
let
  cleanedArgs = builtins.removeAttrs args [ "pname" "name" "version" "src" "meta" "extraBuildInputs" ];
in stdenv.mkDerivation (rec {
  inherit pname version src meta;

  # Don't remove runtime deps.
  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper wrapGAppsHook dpkg ];
  buildInputs = extraBuildInputs ++ (with xorg; [
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
    mesa #libgbm
    gtk3
    atk
    glib
    pango
    gdk-pixbuf
    cairo
    freetype
    fontconfig
    dbus
    nss
    nspr
    alsa-lib
    cups
    expat
    stdenv.cc.cc
  ];
  runtimeDependencies = [ libglvnd stdenv.cc.cc.lib (lib.getLib udev) libnotify libappindicator-gtk3 ];

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
    # make xdg-open overrideable at runtime
    wrapProgram $out/opt/${name}/${pname} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDependencies}" \
      --suffix PATH : ${xdg-utils}/bin \
      "''${gappsWrapperArgs[@]}"
  '';
} // cleanedArgs)
