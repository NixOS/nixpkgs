{
  lib,
  stdenv,
  fetchFromGitHub,

  writableTmpDirAsHomeHook,
  copyDesktopItems,
  makeDesktopItem,

  godotPackages_4_6,
}:
let
  inherit (godotPackages_4_6) godot export-template;
  preset = if stdenv.hostPlatform.isLinux then "Linux x86" else throw "unsupported platform";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "smb1r";
  version = "1.1-stable";

  src = fetchFromGitHub {
    owner = "JHDev2006";
    repo = "Super-Mario-Bros.-Remastered-Public";
    rev = finalAttrs.version;
    hash = "sha256-2js1i2hQRw9ZNkj7587EZzVOt3ylOVW3WOpIEA/72Fk=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    copyDesktopItems
    godot
  ];

  inherit (godot) buildInputs;

  buildPhase = ''
    runHook preBuild

    mkdir -p $HOME/.local/share/godot
    ln -s ${export-template}/share/godot/export_templates $HOME/.local/share/godot

    mkdir -p $out/share/smb1r
    godot --headless --export-release "${preset}" $out/share/smb1r/smb1r

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s $out/share/smb1r/smb1r $out/bin

    install -Dm644 icon.png $out/share/icons/hicolor/256x256/apps/smb1r.png
    install -Dm644 icon32.png $out/share/icons/hicolor/32x32/apps/smb1r.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "smb1r";
      desktopName = "Super Mario Bros. Remastered";
      comment = "Remake / Celebration of the original 'Super Mario Bros.' games";
      exec = "smb1r";
      icon = "smb1r";
      categories = [
        "Game"
        "ActionGame"
      ];
      keywords = [
        "Mario"
        "Bros"
        "Remastered"
        "Remake"
        "Godot"
      ];
    })
  ];

  meta = {
    description = "Remake / Celebration of the original 'Super Mario Bros.' games";
    longDescription = ''
      A Remake / Celebration of the original 'Super Mario Bros.' games. Features new
      levels, custom modes, new characters, alongside a full level editor / custom
      level system!

      Requires an original SMB1 NES ROM to play.
    '';
    homepage = "https://github.com/JHDev2006/Super-Mario-Bros.-Remastered-Public";
    downloadPage = "https://github.com/JHDev2006/Super-Mario-Bros.-Remastered-Public/releases";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ AugustDeer ];
  };
})
