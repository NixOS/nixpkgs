{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
  p7zip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rounded-mgenplus";
  version = "20150602";

  src = fetchurl {
    url = "mirror://osdn/users/8/8598/${finalAttrs.pname}-${finalAttrs.version}.7z";
    hash = "sha256-7OpnZJc9k5NiOPHAbtJGMQvsMg9j81DCvbfo0f7uJcw=";
  };

  sourceRoot = ".";

  __srtucturedAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    installFonts
    p7zip
  ];

  meta = {
    description = "Japanese font based on Rounded M+ and Noto Sans Japanese";
    homepage = "http://jikasei.me/font/rounded-mgenplus/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      mnacamura
      shadowrz
    ];
  };
})
