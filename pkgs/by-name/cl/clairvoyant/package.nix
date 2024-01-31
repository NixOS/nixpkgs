{ lib
, fetchFromGitHub
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, stdenv
, vala
, wrapGAppsHook4
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clairvoyant";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "clairvoyant";
    rev = finalAttrs.version;
    hash = "sha256-eAcd8JJmcsz8dm049g5xsF6gPpNQ6ZvGGIhKAoMlPTU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  meta = with lib; {
    changelog = "https://github.com/cassidyjames/clairvoyant/releases/tag/${finalAttrs.version}";
    description = "Ask questions and get psychic answers";
    homepage = "https://github.com/cassidyjames/clairvoyant";
    license = licenses.gpl3Plus;
    mainProgram = "com.github.cassidyjames.clairvoyant";
    maintainers = with maintainers; [ michaelgrahamevans ];
  };
})
