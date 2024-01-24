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
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = pname;
    rev = version;
    hash = "sha256-q+yN3FAs1L+GzagOQRK5gw8ptBpHPqWOiCL6aaoWcJo=";
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
