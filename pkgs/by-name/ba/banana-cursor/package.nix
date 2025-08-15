{
  clickgen,
  fetchFromGitHub,
  fetchzip,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "banana-cursor";
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

  buildPhase = ''
    runHook preBuild

    for dir in "$bitmaps"/*/; do
      theme_name=$(basename "$dir")
      ctgen configs/x.build.toml --platforms x11 --bitmaps-dir "$dir" --theme-name "$theme_name" --out-dir $out/share/icons
    done

    runHook postBuild
  '';

  meta = {
    description = "Banana Cursor";
    homepage = "https://github.com/ful1e5/banana-cursor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      getpsyched
      yrd
    ];
    platforms = lib.platforms.linux;
  };
})
