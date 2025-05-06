{
  lib,
  requireFile,
  runCommand,
  writeShellScript,
  buildFHSEnv,
  makeDesktopItem,
  fetchurl,
}:

let
  pname = "spine-pro";

  spineTarball = requireFile rec {
    name = pname;
    url = "https://eu.esotericsoftware.com/";
    message = ''
      Unfortunately, we cannot download file ${name} automatically.
      Please run the following command replacing LICENSE_KEY with your Spine license key to download it manually.
        nix-prefetch-url --name spine-pro --type sha256 https://eu.esotericsoftware.com/launcher/linux/LICENSE_KEY
    '';
    sha256 = "0ayja2p6p4wkgiqw2f5xvbifh55gicvhxbwm5yh9b9hwwhxx28z5";
  };

  unpackedSpine = runCommand "spine-pro-unpacked" { } ''
    mkdir -p $out
    tar -xzf ${spineTarball} -C $out --strip-components=1
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    desktopName = "Spine";
    type = "Application";
    icon = fetchurl {
      url = "http://esotericsoftware.com/files/branding/spine_badge.png";
      sha256 = "sha256-1vZg+ViV+Q9nmijGlYNu5E8MF5nRGXrvT4iAdFdlQ2A=";
    };
  };

in
buildFHSEnv {
  inherit pname;
  version = "4.2.39";

  runScript = writeShellScript "spine-launcher" ''
    ${unpackedSpine}/launcher/2/bin/java \
      -Xms512m -Xmx4096m \
      com.esotericsoftware.spine.launcher.Launcher
  '';

  targetPkgs =
    pkgs: with pkgs; [
      zlib
      freetype
      fontconfig

      libGL
      libglvnd
      mesa.drivers
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXtst
      xorg.libXi
      xorg.libXrandr
      xorg.libXcursor
      xorg.libXxf86vm

      alsa-lib
      libpulseaudio
      udev
    ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications/
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
  '';

  meta = {
    description = "2D skeletal animation for games";
    homepage = "https://esotericsoftware.com/";
    changelog = "https://en.esotericsoftware.com/spine-changelog";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ justryanw ];
    mainProgram = "spine-pro";
    platforms = lib.platforms.linux;
  };
}
