{
  clickgen,
  fetchFromGitHub,
  fetchzip,
  lib,
  stdenvNoCC,
}:

let
  colors = [
    "blue"
    "green"
    "red"
    "yellow"
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "banana-cursors";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "banana-cursor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DSgc3y4T/mWO9KC6KBy5W7M8TMM0s4U4pnr/Zy3yTMM=";
  };

  bitmaps = fetchzip {
    url = "https://github.com/ful1e5/banana-cursor/releases/download/v${finalAttrs.version}/bitmaps.zip";
    hash = "sha256-EOs5gzd2K75EKvMPHnxpjDPQpbckb/RkosrZB6JxDlk=";
  };

  nativeBuildInputs = [
    clickgen
  ];

  outputs = [ "out" ] ++ colors;

  buildPhase = ''
    runHook preBuild

    for dir in "$bitmaps"/*/; do
      local theme_name=$(basename "$dir")
      ctgen configs/x.build.toml --platforms x11 --bitmaps-dir "$dir" --theme-name "$theme_name"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for output in $(getAllOutputNames); do
      if [ "$output" == "out" ]; then
        ln -s "$yellow" "$out"
        continue
      fi

      local outputDir="''${!output}"
      local iconsDir="$outputDir"/share/icons
      mkdir -p "$iconsDir"

      if [ "$output" == "yellow" ]; then
        mv "themes/Banana" "$iconsDir"
      else
        mv "themes/Banana-''${output^}" "$iconsDir"
      fi
    done

    runHook postInstall
  '';

  meta = {
    description = "Banana Cursors";
    homepage = "https://github.com/ful1e5/banana-cursor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getpsyched ];
    platforms = lib.platforms.linux;
  };
})
