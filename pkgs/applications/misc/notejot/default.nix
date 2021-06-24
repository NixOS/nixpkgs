{ lib, stdenv, fetchFromGitHub, nix-update-script, vala, pkg-config, meson, ninja, python3, pantheon
, gtk3, gtksourceview, json-glib, libgee, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "notejot";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "170dzgd6cnf2k3hfifjysmdggpskx6v1pjmblqgbwaj2d3snf3h8";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gtksourceview
    json-glib
    libgee
    pantheon.elementary-icon-theme
    pantheon.granite
  ];

  postPatch = ''
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Stupidly-simple sticky notes applet";
    homepage = "https://github.com/lainsce/notejot";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
