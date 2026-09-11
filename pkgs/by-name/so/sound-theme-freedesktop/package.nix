{
  lib,
  stdenv,
  fetchurl,
  intltool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sound-theme-freedesktop";
  version = "0.8";

  src = fetchurl {
    sha256 = "054abv4gmfk9maw93fis0bf605rc56dah7ys5plc4pphxqh8nlfb";
    url = "https://people.freedesktop.org/~mccann/dist/sound-theme-freedesktop-${finalAttrs.version}.tar.bz2";
  };

  nativeBuildInputs = [ intltool ];

  meta = {
    description = "Freedesktop reference sound theme";
    homepage = "http://freedesktop.org/wiki/Specifications/sound-theme-spec";
    # See http://cgit.freedesktop.org/sound-theme-freedesktop/tree/CREDITS:
    license = with lib.licenses; [
      cc-by-30
      cc-by-sa-25
      gpl2
      gpl2Plus
    ];
    platforms = with lib.platforms; unix;
  };
})
