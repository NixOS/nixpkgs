{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "react-jsx-i18n";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "indico";
    repo = "react-jsx-i18n";
    rev = "v${version}";
    hash = "sha256-GQbjKG3Nr57cMVudCKA4Mo6aopsSrVQ9tyTvYciLv/s=";
  };

  npmDepsHash = "sha256-JK2Z18agCXEAMu6hBpYDHc+RmmwlIpHoOXexda+pauA=";

  meta = with lib; {
    description = "Gettext-enhanced React components";
    homepage = "https://github.com/indico/react-jsx-i18n";
    license = licenses.mit;
    maintainers = with maintainers; [ thubrecht ];
    mainProgram = "react-jsx-i18n";
    platforms = platforms.all;
  };
}
