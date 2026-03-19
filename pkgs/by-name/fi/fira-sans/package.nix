{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fira-sans";
  version = "4.301";
  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url = "https://carrois.com/downloads/Fira/Download_Folder_FiraSans_${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }.zip";
    hash = "sha256-WBt3oqPK7ACqMhilYkyFx9Ek2ugwdCDFZN+8HLRnGRs";
    stripRoot = false;
  };

  postInstall = ''
    rm -r "__MACOSX"
  '';

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://carrois.com/fira/";
    description = "Sans-serif font for Firefox OS";
    longDescription = ''
      Fira Sans is a sans-serif font designed by Erik Spiekermann,
      Ralph du Carrois, Anja Meiners and Botio Nikoltchev of Carrois
      Type Design for Mozilla Firefox OS.  It is closely related to
      Spiekermann's FF Meta typeface.  Available in Two, Four, Eight,
      Hair, Thin, Ultra Light, Extra Light, Light, Book, Regular,
      Medium, Semi Bold, Bold, Extra Bold, Heavy weights with
      corresponding italic versions.
    '';
    maintainers = with lib.maintainers; [ pancaek ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
