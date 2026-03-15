{
  lib,
  stdenvNoCC,
  electron,
  requireFile,
  fetchurl,
  makeWrapper,
  unzip,
  copyDesktopItems,
  makeDesktopItem,
  imagemagick,
}:

stdenvNoCC.mkDerivation {
  pname = "neoditronix";
  version = "1.0.2";

  src = requireFile {
    name = "neoditronix-win.zip";
    url = "https://ohm002log.itch.io/neoditronix";
    hash = "sha256-Q6XXls2wYTJVgGqBEuhbzfpCSp4NA9S8poJpUe1pGhA=";
  };

  iconSrc = fetchurl {
    url = "https://shared.fastly.steamstatic.com/community_assets/images/apps/3782120/27bb86693fce16d725a7a51118ed961ddc9eb003.ico";
    hash = "sha256-RE+8yv3gCyjRPIj5vJSME/M89rIqm1xuiixQI4/Di0U=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    unzip
    imagemagick
    copyDesktopItems
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/neoditronix
    unzip $src resources/app.asar -d $out/opt/neoditronix
    makeWrapper ${lib.getExe electron} $out/bin/neoditronix \
      --add-flags "$out/opt/neoditronix/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0 \
      --run "h=\"\''${XDG_DATA_DIR:-\$HOME/.local/share}/neoditronix\"; mkdir -p \"\$h\"; cd \"\$h\""

    magick identify -format "%s %wx%h\n" "$iconSrc" | while read i size; do
      dir="$out/share/icons/hicolor/$size/apps"
      mkdir -p "$dir"
      magick "$iconSrc[$i]" "$dir/neoditronix.png"
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "neoditronix";
      desktopName = "neoditronix";
      genericName = "NEODITRONIX";
      exec = "neoditronix";
      icon = "neoditronix";
      comment = "Dreamcore rhythm game";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "Dreamcore rhythm game";
    homepage = "https://ohm002log.itch.io/neoditronix";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.all;
  };
}
