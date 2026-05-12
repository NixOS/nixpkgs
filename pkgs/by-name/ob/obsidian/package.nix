{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  makeDesktopItem,
  imagemagick,
  writeScript,
  pkgs,
  commandLineArgs ? "",
}:
let
  pname = "obsidian";
  version = "1.12.7";
  appname = "Obsidian";
  meta = {
    description = "Powerful knowledge base that works on top of a local folder of plain text Markdown files";
    homepage = "https://obsidian.md";
    downloadPage = "https://github.com/obsidianmd/obsidian-releases/releases";
    mainProgram = "obsidian";
    license = lib.licenses.obsidian;
    maintainers = with lib.maintainers; [
      conradmearns
      zaninime
      kashw2
      w-lfchen
      prince213
    ];

    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

  filename =
    if stdenv.hostPlatform.isDarwin then "Obsidian-${version}.dmg" else "obsidian-${version}.tar.gz";
  src = fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/${filename}";
    hash =
      if stdenv.hostPlatform.isDarwin then
        "sha256-O4XBO0zlVRLobhcKfNKklOLbaVrIiMBgHhU8uFt3iBs="
      else
        "sha256-/L4IsRHZwf2wm5wIlSsG4cgpxiFj66JYTEtOyFm+B50=";
  };

  icon = fetchurl {
    url = "https://obsidian.md/images/obsidian-logo-gradient.svg";
    hash = "sha256-EZsBuWyZ9zYJh0LDKfRAMTtnY70q6iLK/ggXlplDEoA=";
  };

  desktopItem = makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian";
    comment = "Knowledge base";
    icon = "obsidian";
    exec = "obsidian %u";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/obsidian" ];
  };

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      desktopItem
      icon
      meta
      ;
    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      imagemagick
    ];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      alsa-lib
      atk
      at-spi2-atk
      at-spi2-core
      cups
      dbus
      gtk3
      gsettings-desktop-schemas
      libdrm
      libglvnd
      libsecret
      libxkbcommon
      mesa
      nspr
      nss
      systemd
      vulkan-loader
      libx11
      libxcomposite
      libxdamage
      libxfixes
      libxrandr
      libxcb
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/obsidian

      # Copy extracted contents to the share directory
      cp -a ./* $out/share/obsidian/

      # The bundled Electron wrapper executable
      OBSIDIAN_BIN="$out/share/obsidian/obsidian"
      chmod +x "$OBSIDIAN_BIN"

      # Wrap the BUNDLED binary with explicit runtime paths
      makeWrapper "$OBSIDIAN_BIN" $out/bin/obsidian \
        --run 'if ${pkgs.procps}/bin/pgrep -f "gnome-keyring" >/dev/null 2>&1; then export _OBS_PASS="--password-store=gnome-libsecret"; elif ${pkgs.procps}/bin/pgrep -f "kwallet" >/dev/null 2>&1; then export _OBS_PASS="--password-store=kwallet6"; else export _OBS_PASS=""; fi' \
        --add-flags "\$_OBS_PASS" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true --wayland-text-input-version=3}}" \
        --add-flags ${lib.escapeShellArg commandLineArgs} \
        --set LD_LIBRARY_PATH "${
          lib.makeLibraryPath [
            pkgs.libglvnd
            pkgs.mesa
            pkgs.vulkan-loader
            pkgs.libsecret
          ]
        }" \
        --set GSETTINGS_SCHEMA_DIR "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}" \
        --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share:${pkgs.gsettings-desktop-schemas}/share"

      # Install CLI if present
      if [ -f "$out/share/obsidian/obsidian-cli" ]; then
        install -m 755 -D "$out/share/obsidian/obsidian-cli" $out/bin/obsidian-cli
      fi

      # Install desktop entry
      install -m 444 -D "${desktopItem}/share/applications/"* -t $out/share/applications/

      # Generate icons from SVG
      for size in 16 24 32 48 64 128 256 512; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick -background none ${icon} -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
      done

      runHook postInstall
    '';

    passthru.updateScript = writeScript "updater" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts
      set -eu -o pipefail
      latestVersion="$(curl -sS https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/desktop-releases.json | jq -r '.latestVersion')"
      update-source-version obsidian "$latestVersion"
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      appname
      meta
      ;
    sourceRoot = "${appname}.app";
    nativeBuildInputs = [
      makeWrapper
    ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/{Applications/${appname}.app,bin}
      cp -R . $out/Applications/${appname}.app
      makeWrapper $out/Applications/${appname}.app/Contents/MacOS/${appname} $out/bin/obsidian
      if [ -f "$out/Applications/${appname}.app/Contents/MacOS/obsidian-cli" ]; then
        makeWrapper $out/Applications/${appname}.app/Contents/MacOS/obsidian-cli $out/bin/obsidian-cli
      fi
      runHook postInstall
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
