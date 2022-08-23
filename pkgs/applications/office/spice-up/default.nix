{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, glib
, gtk3
, json-glib
, libevdev
, libgee
, libgudev
, libsoup
, pantheon
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
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    json-glib
    libevdev
    libgee
    libgudev
    libsoup
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Create simple and beautiful presentations";
    homepage = "https://github.com/Philip-Scott/Spice-up";
    maintainers = with maintainers; [ samdroid-apps xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    # The COPYING file has GPLv3; some files have GPLv2+ and some have GPLv3+
    license = licenses.gpl3Plus;
    mainProgram = "com.github.philip_scott.spice-up";
  };
}
