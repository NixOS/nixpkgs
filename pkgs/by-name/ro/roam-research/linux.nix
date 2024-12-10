{
  stdenv,
  lib,
  fetchurl,
  alsa-lib,
  atk,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libdrm,
  libpulseaudio,
  libxcb,
  libxkbcommon,
  libxshmfence,
  mesa,
  nspr,
  nss,
  pango,
  udev,
}:

let
  common = import ./common.nix { inherit fetchurl; };
  inherit (stdenv.hostPlatform) system;
  libPath = lib.makeLibraryPath [
    alsa-lib
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libdrm
    libxcb
    libxkbcommon
    libxshmfence
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc
    libXScrnSaver
    libXcursor
    libXrender
    libXtst
    libpulseaudio
    udev
  ];
in
stdenv.mkDerivation rec {
  inherit (common) pname version;
  src = common.sources.${system} or (throw "Source for ${pname} is not available for ${system}");

  nativeBuildInputs = [ dpkg ];

  installPhase = ''
    mkdir -p "$out/bin"
    mv opt "$out/"

    ln -s "$out/opt/Roam Research/roam-research" "$out/bin/roam-research"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:$out/opt/Roam Research:\$ORIGIN" "$out/opt/Roam Research/roam-research"

    mv usr/* "$out/"

    substituteInPlace $out/share/applications/roam-research.desktop \
      --replace "/opt/Roam Research/roam-research" "roam-research"
  '';

  # autoPatchelfHook/patchelf are not used because they cause the binary to coredump.
  dontPatchELF = true;

  meta = with lib; {
    description = "Note-taking tool for networked thought";
    homepage = "https://roamresearch.com/";
    maintainers = with lib.maintainers; [ dbalan ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "roam-research";
  };
}
