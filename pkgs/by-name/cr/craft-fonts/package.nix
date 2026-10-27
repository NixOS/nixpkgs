{
  fetchFromGitHub,
  installFonts,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "craft-fonts";
  version = "0-unstable-2026-10-11";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-fonts";
    rev = "3d9ab3a132ed0eff457e424226a435a901da30d3";
    hash = "sha256-mNnDzBcOp1X10dzmiW0iBAkb74QjuzMO4slWudxXCTE=";
  };

  nativeBuildInputs = [ installFonts ];

  # The apps read fonts/manifest.txt and the paths it lists from CRAFT_FONTS_DIR,
  # so mirror upstream's tree here, symlinking to the fonts installFonts installed
  # instead of copying them, so each font only exists once in $out.
  postInstall = ''
    install -d $out/fonts
    install -m644 fonts/manifest.txt $out/fonts/

    for dir in fonts/*/; do
      family=$(basename "$dir")
      install -d "$out/fonts/$family"
      for file in "$dir"*; do
        case $file in
          *.ttf) ln -s "$out/share/fonts/truetype/$(basename "$file")" "$out/fonts/$family/" ;;
          *.otf) ln -s "$out/share/fonts/opentype/$(basename "$file")" "$out/fonts/$family/" ;;
          *) install -m644 "$file" "$out/fonts/$family/" ;;
        esac
      done
    done
  '';

  meta = {
    description = "Shared font bundle for the ArtCraft application suite (CRAFT_FONTS_DIR)";
    homepage = "https://github.com/storytold/craft-fonts";
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        ofl
      ];
    maintainers = with lib.maintainers; [
      cleboost
      gaelj
    ];
    platforms = lib.platforms.all;
  };
}
