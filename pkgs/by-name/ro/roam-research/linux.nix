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
  libx11,
  libxscrnsaver,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libdrm,
  libpulseaudio,
  libxcb,
  libxkbcommon,
  libxshmfence,
  libgbm,
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
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libdrm
    libxcb
    libxkbcommon
    libxshmfence
    libgbm
    nspr
    nss
    pango
    stdenv.cc.cc
    libxscrnsaver
    libxcursor
    libxrender
    libxtst
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

  meta = {
    description = "Note-taking tool for networked thought";
    homepage = "https://roamresearch.com/";
    maintainers = with lib.maintainers; [ dbalan ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "roam-research";
  };
}
