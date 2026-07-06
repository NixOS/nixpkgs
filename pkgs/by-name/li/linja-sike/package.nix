{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "linja-sike";
  version = "5.0";

  src = fetchurl {
    url = "https://lipamanka.gay/linja-sike-5.otf";
    hash = "sha256-TJcKIK6byBb9/zyoKHTmhMpOGwHYG/ZPmm72huSO/Yo=";
  };

  dontUnpack = true;

  __structuredAttrs = true;

  stripDeps = true;

  postPatch = "cp $src linja-sike-5.otf";

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Extensive sitelen pona font by lipamanka";
    homepage = "https://docs.google.com/document/d/1d8kUIAVlB-JNgK3LWr_zVCuUOZTh2hF7CfC6xQgxsBs/edit?usp=sharing";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ somasis ];
  };
}
