{
  stdenv,
  lib,
  makeWrapper,
  wrapGAppsHook3,
  autoPatchelfHook,
  dpkg,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  atk,
  glib,
  pango,
  gdk-pixbuf,
  cairo,
  freetype,
  fontconfig,
  gtk3,
  dbus,
  nss,
  nspr,
  alsa-lib,
  cups,
  expat,
  udev,
  libnotify,
  xdg-utils,
  libgbm,
  libglvnd,
  libappindicator-gtk3,
  pipewire,
  libpulseaudio,
}:

# Helper function for building a derivation for Franz and forks.

{
  pname,
  name,
  version,
  src,
  meta,
  extraBuildInputs ? [ ],
  ...
}@args:
let
  cleanedArgs = removeAttrs args [
    "pname"
    "name"
    "version"
    "src"
    "meta"
    "extraBuildInputs"
  ];
in
stdenv.mkDerivation (
  rec {
    inherit
      pname
      version
      src
      meta
      ;

    # Don't remove runtime deps.
    dontPatchELF = true;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      wrapGAppsHook3
      dpkg
    ];
    buildInputs =
      extraBuildInputs
      ++ [
        libxi
        libxcursor
        libxdamage
        libxrandr
        libxcomposite
        libxext
        libxfixes
        libxrender
        libx11
        libxtst
        libxscrnsaver
      ]
      ++ [
        libgbm
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
        pipewire
        libpulseaudio
      ];
    runtimeDependencies = [
      libglvnd
      (lib.getLib stdenv.cc.cc)
      (lib.getLib udev)
      libnotify
      libappindicator-gtk3
      pipewire
      libpulseaudio
    ];

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
      # make xdg-open overridable at runtime
      wrapProgramShell $out/opt/${name}/${pname} \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDependencies}" \
        --suffix PATH : ${xdg-utils}/bin \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer --enable-wayland-ime=true}}" \
        "''${gappsWrapperArgs[@]}"
    '';
  }
  // cleanedArgs
)
