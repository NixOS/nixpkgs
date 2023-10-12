{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, pango
, cairo
, gtk2
}:

buildGoModule rec {
  pname = "hasmail-unstable";
  version = "2019-08-24";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "hasmail";
    rev = "eb52536d26815383bfe5990cd5ace8bb9d036c8d";
    hash = "sha256-QcUk2+JmKWfmCy46i9gna5brWS4r/D6nC6uG2Yvi09w=";
  };

  vendorHash = "sha256-kWGNsCekWI7ykcM4k6qukkQtyx3pnPerkb0WiFHeMIk=";

  doCheck = false;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pango
    cairo
    gtk2
  ];

  meta = with lib; {
    description = "Simple tray icon for detecting new email on IMAP servers";
    homepage = "https://github.com/jonhoo/hasmail";
    license = licenses.unlicense;
    maintainers = with maintainers; [ doronbehar ];
  };
}
