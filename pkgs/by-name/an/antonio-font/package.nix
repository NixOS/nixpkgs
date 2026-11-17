{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "antonio";
  version = "0-unstable-2013-11-21";

  src = fetchFromGitHub {
    owner = "vernnobile";
    repo = "antonioFont";
    rev = "4b3e07ab5647a613931153a09067a785f54b980a";
    hash = "sha256-/mlVAEMkhmj6NUcAa9HHtpWw4lS5ze9IXw9IsrHd2J0=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    cp $src/{Bold,Light,Regular}/*.ttf $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/vernnobile/antonioFont";
    description = "Condensed, sans serif font for larger display, headline & banner use, based on Anton";
    longDescription = ''
      Antonio is a ‘refined’ version of the Anton Font. Anton is a single
      weight web font, designed specifically for larger display, headline and
      ‘banner’ use (see Google’s PR for the Chromebook notebooks that used
      Anton, big and bright).

      Antonio extends the Anton design to include more weights and introduces
      refinements to the design that makes it also suitable for use in smaller
      headings, menus and ‘buttons’ etc.
    '';
    license = lib.licenses.ofl; # in fontinfo.plist files
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ toastal ];
  };
}
