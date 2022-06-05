{ lib, stdenv, fetchFromGitHub, sqlite, wxGTK30, gettext, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "money-manager-ex";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "moneymanagerex";
    repo = "moneymanagerex";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-5NgkP9gY4eDBoKSC/IaXiHoiz+ZdU4c/iGAzPf5IlmQ=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  buildInputs = [
    gettext
    sqlite
    wxGTK30
    wxGTK30.gtk
  ];

  meta = {
    description = "Easy-to-use personal finance software";
    homepage = "https://www.moneymanagerex.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}
