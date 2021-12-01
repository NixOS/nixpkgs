{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, vala
, meson
, ninja
, pkg-config
, pantheon
, python3
, gettext
, glib
, gtk3
, libgee
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "appeditor";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "donadigo";
    repo = "appeditor";
    rev = version;
    sha256 = "14ycw1b6v2sa4vljpnx2lpx4w89mparsxk6s8w3yx4dqjglcg5bp";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    pantheon.granite
    libgee
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
    description = "Edit the Pantheon desktop application menu";
    homepage = "https://github.com/donadigo/appeditor";
    maintainers = with maintainers; [ xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    mainProgram = "com.github.donadigo.appeditor";
  };
}
