{
  appimageTools,
  fetchurl,
  makeDesktopItem,
  lib,
  libxshmfence,
  coreutils,
  writeText,
  wayland,
  wayland-protocols,
}:
let
  pname = "lycheeslicer";
  version = "8.0.3";

  src = fetchurl {
    url = "https://mango-lychee.nyc3.cdn.digitaloceanspaces.com/LycheeSlicer-${version}-x86_64.GLIB-235.AppImage";
    hash = "sha256-djXiUB2hak7pcmmHQAm/bWOk7b9YHHRQbgriLRN11Ik=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

  # LycheeSlicer 8 regenerates this on every start (for the OAuth login callback),
  # with Exec= pointing at the unwrapped binary, which can't run outside the FHS env.
  urlHandler = writeText "lycheeslicer-url-handler.desktop" ''
    [Desktop Entry]
    Type=Application
    Name=LycheeSlicer URL Handler
    Exec=lycheeslicer %u
    StartupNotify=false
    Terminal=false
    NoDisplay=true
    MimeType=x-scheme-handler/lycheeslicer;
  '';

  desktopItem = makeDesktopItem {
    name = "lycheeslicer";
    desktopName = "LycheeSlicer";
    genericName = "Resin Slicer";
    comment = "All-in-one 3D slicer for Resin and Filament";
    icon = "lycheeslicer";
    exec = "lycheeslicer %U";
    terminal = false;
    mimeTypes = [
      "application/x-lychee-slicer"
      "application/x-lycheeslicer-scene"
      "model/stl"
      "x-scheme-handler/lycheeslicer"
    ];
    categories = [
      "Graphics"
      "3DGraphics"
      "Engineering"
    ];
    keywords = [
      "3d"
      "STL"
      "Slicer"
      "Printing"
    ];
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/*
    ln -s lycheeslicer.desktop $out/share/applications/LycheeSlicer.desktop
    ln -s lycheeslicer.desktop $out/share/applications/lychee-slicer.desktop
    ln -s lycheeslicer.desktop "$out/share/applications/Lychee Slicer.desktop"

    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/scalable/apps/LycheeSlicer.svg \
      $out/share/icons/hicolor/scalable/apps/lycheeslicer.svg
    ln -s lycheeslicer.svg $out/share/icons/hicolor/scalable/apps/LycheeSlicer.svg
  '';

  extraPkgs = _: [
    libxshmfence
    wayland
    wayland-protocols
  ];

  extraPreBwrapCmds = ''
    # Install the URL handler read-only, so the app can't overwrite it with a broken one.
    handler="$HOME/.local/share/applications/lycheeslicer-url-handler.desktop"
    ${coreutils}/bin/rm -f "$handler"
    ${coreutils}/bin/install -Dm444 ${urlHandler} "$handler"

    # The license check reads the machine UUID only from /var/lib/dbus/machine-id,
    # which NixOS doesn't have. The host /var is bind-mounted, so bwrap can't add it
    # there: put a tmpfs over /var/lib, rebind the host entries and add machine-id.
    varlib_mounts=(--tmpfs /var/lib)
    for d in /var/lib/*; do
      [[ $d == /var/lib/dbus ]] || varlib_mounts+=(--bind "$d" "$d")
    done
    varlib_mounts+=(--ro-bind /etc/machine-id /var/lib/dbus/machine-id)
  '';

  extraBwrapArgs = [ "\"\${varlib_mounts[@]}\"" ];

  meta = {
    description = "All-in-one 3D slicer for resin and FDM printers";
    homepage = "https://lychee.mango3d.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      tarinaky
      ZachDavies
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "lycheeslicer";
  };
}
