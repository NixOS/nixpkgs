{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vala
, blueprint-compiler
, wrapGAppsHook4
, desktop-file-utils
, libadwaita
, libgee
, gtksourceview5
}:

stdenv.mkDerivation rec {
  pname = "folio";
  version = "24.12";

  src = fetchFromGitHub {
    owner = "toolstack";
    repo = "Folio";
    rev = version;
    hash = "sha256-0Aq8R+5k5LCmciRHauTvxuJWCyN3FN4sP9aEPNlMn+k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    libgee
    gtksourceview5
  ];

  meta = with lib; {
    description = "Beautiful markdown note-taking app for GNOME (forked from Paper)";
    homepage = "https://github.com/toolstack/Folio";
    license = licenses.gpl3Only;
    mainProgram = "com.toolstack.Folio";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
