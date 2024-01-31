{ lib
, fetchFromGitHub
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, stdenv
, vala
}:

stdenv.mkDerivation rec {
  pname = "clairvoyant";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = pname;
    rev = version;
    hash = "sha256-eAcd8JJmcsz8dm049g5xsF6gPpNQ6ZvGGIhKAoMlPTU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "Ask questions and get psychic answers";
    homepage = "https://github.com/cassidyjames/clairvoyant";
    changelog = "https://github.com/cassidyjames/clairvoyant/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ michaelgrahamevans ];
    mainProgram = "com.github.cassidyjames.clairvoyant";
  };
}
