{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "inter";
  version = "4.1";

  src = fetchzip {
    url = "https://github.com/rsms/inter/releases/download/v${finalAttrs.version}/Inter-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-5vdKKvHAeZi6igrfpbOdhZlDX2/5+UvzlnCQV6DdqoQ=";
  };

  nativeBuildInputs = [ installFonts ];
  postPatch = ''
    rm extras/ -rf
  '';

  dontInstallWebfonts = true;

  __structuredAttrs = true;

  meta = {
    homepage = "https://rsms.me/inter/";
    description = "Typeface specially designed for user interfaces";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ demize ];
  };
})
