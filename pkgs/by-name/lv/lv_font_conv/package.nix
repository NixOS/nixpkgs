{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "lv_font_conv";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "lvgl";
    repo = "lv_font_conv";
    rev = version;
    hash = "sha256-tm6xPOW0pOO02M10O1H7ww+yXWq/DJtbDmlfrJ6Lp4Y=";
  };

  npmDepsHash = "sha256-nNMcOL3uu77e4qLoWGhtBgNQXxeEU+kUuKAc25a8fUc=";

  preBuild = ''
    patchShebangs support/build_web.js
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Converts TTF/WOFF fonts to compact bitmap format";
    mainProgram = "lv_font_conv";
    homepage = " https://lvgl.io/tools/fontconverter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
