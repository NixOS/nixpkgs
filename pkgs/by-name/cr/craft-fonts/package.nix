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

  installPhase = ''
    runHook preInstall

    # ArtCraft build uses CRAFT_FONTS_DIR with upstream's fonts/ tree (not fontconfig paths).
    cp -r fonts $out/fonts

    install -d $out/share/doc/craft-fonts
    install -m644 ATTRIBUTION.md README.md LICENSE-MIT LICENSE-APACHE \
      $out/share/doc/craft-fonts/

    runHook postInstall
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
