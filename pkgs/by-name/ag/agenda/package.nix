{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, python3
, pkg-config
, vala
, gettext
, glib
, gtk3
, libgee
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "agenda";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "dahenson";
    repo = pname;
    rev = version;
    sha256 = "sha256-tzGcqCxIkoBNskpadEqv289Sj5bij9u+LdYySiGdop8=";
  };

  nativeBuildInputs = [
    gettext
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libgee
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Simple, fast, no-nonsense to-do (task) list designed for elementary OS";
    homepage = "https://github.com/dahenson/agenda";
    maintainers = with maintainers; [ xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    license = licenses.gpl3;
    mainProgram = "com.github.dahenson.agenda";
  };
}

