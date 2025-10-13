{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "sorts-mill-goudy";
  version = "2011-05-25";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = "sorts-mill-goudy";
    rev = "06072890c7b05f274215a24f17449655ccb2c8af";
    hash = "sha256-NEfLBJatUmdUL5gJEimJHZfOd1OtI7pxTN97eWMODyM=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/*.ttf
    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "‘revival’ of Goudy Oldstyle and Italic";
    longDescription = ''
      A 'revival' of Goudy Oldstyle and Italic, with features including small
      capitals (in the roman only), oldstyle and lining figures, superscripts
      and subscripts, fractions, ligatures, class-based kerning, case-sensitive
      forms, and capital spacing. There is support for many languages using
      latin scripts.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/sorts-mill-goudy";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
