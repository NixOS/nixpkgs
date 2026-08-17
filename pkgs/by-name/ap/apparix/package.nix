{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apparix";
  version = "11-062";

  src = fetchurl {
    url = "https://micans.org/apparix/src/apparix-${finalAttrs.version}.tar.gz";
    sha256 = "211bb5f67b32ba7c3e044a13e4e79eb998ca017538e9f4b06bc92d5953615235";
  };

  doCheck = true;

  meta = {
    homepage = "http://micans.org/apparix";
    description = "Add directory bookmarks, distant listing, and distant editing to the command line";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "apparix";
  };
})
