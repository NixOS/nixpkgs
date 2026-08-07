{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sarasa-gothic";
  version = "1.0.40";

  src = fetchurl {
    # Use the 'ttc' files here for a smaller closure size.
    # (Using 'ttf' files gives a closure size about 15x larger, as of November 2021.)
    url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${finalAttrs.version}/Sarasa-TTC-${finalAttrs.version}.zip";
    hash = "sha256-riWSPs+KJEhKJ+L683CKjsyYjFfh6Jn1jXNtgsUsyYA=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    installFonts
  ];

  meta = {
    description = "CJK programming font based on Iosevka and Source Han Sans";
    homepage = "https://github.com/be5invis/Sarasa-Gothic";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [
      ChengCat
      wegank
    ];
    platforms = lib.platforms.all;
  };
})
