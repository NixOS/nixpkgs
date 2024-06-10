{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "nom";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "guyfedwards";
    repo = "nom";
    rev = "v${version}";
    hash = "sha256-1KHU+y8aoEdXzP5jUZlTokbv383aKgMt+Wby2bodCTI=";
  };

  vendorHash = "sha256-wWdsLU656wBAUmnVw21wo+a/OLmyhZ2Bq0j8S190XQs=";

  meta = with lib; {
    homepage = "https://github.com/guyfedwards/nom";
    description = "RSS reader for the terminal";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nadir-ishiguro ];
    mainProgram = "nom";
  };
}
