{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  python3,
  vala,
  wrapGAppsHook3,
  glib,
  gtk3,
  json-glib,
  libevdev,
  libgee,
  libgudev,
  libsoup_2_4,
  pantheon,
}:

stdenv.mkDerivation rec {
  pname = "spice-up";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "Philip-Scott";
    repo = "Spice-up";
    rev = version;
    sha256 = "sha256-FI6YMbqZfaU19k8pS2eoNCnX8O8F99SHHOxMwHC5fTc=";
  };

  nativeBuildInputs = [
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
    json-glib
    libevdev
    libgee
    libgudev
    libsoup_2_4
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Create simple and beautiful presentations";
    homepage = "https://github.com/Philip-Scott/Spice-up";
    maintainers = with lib.maintainers; [
      samdroid-apps
      xiorcale
    ];
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    # The COPYING file has GPLv3; some files have GPLv2+ and some have GPLv3+
    license = lib.licenses.gpl3Plus;
    mainProgram = "com.github.philip_scott.spice-up";
  };
}
