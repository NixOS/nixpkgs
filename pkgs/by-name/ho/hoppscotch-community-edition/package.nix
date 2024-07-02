{ fetchFromGitHub
, lib
, stdenv
}:

let
  pname = "hoppscotch-community-edition";
  version = "2024.3.3";

  src = fetchFromGitHub {
    owner = "hoppscotch";
    repo = "hoppscotch";
    rev = version;
    hash = "sha256-QrQYTFxo8YOE5/dZA7g5ZHZiww9c0gn+60mGRylOcsI=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  postInstall = ''
    install -D -m444 ${src}/packages/hoppscotch-common/public/logo.svg $out/share/icons/hicolor/scalable/apps/hoppscotch.svg
  '';

  meta = {
    changelog = "https://hoppscotch.com/changelog";
    description = "Open source API development ecosystem";
    longDescription = ''
      Hoppscotch is a lightweight, web-based API development suite. It was built
      from the ground up with ease of use and accessibility in mind providing
      all the functionality needed for API developers with minimalist,
      unobtrusive UI.
    '';
    homepage = "https://hoppscotch.com";
    downloadPage = "https://hoppscotch.com/downloads";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getpsyched ];
    mainProgram = "hoppscotch";
    platforms = lib.platforms.all;
  };
}
