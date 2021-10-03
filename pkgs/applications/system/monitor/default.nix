{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, vala
, pkg-config
, pantheon
, python3
, gettext
, glib
, gtk3
, libwnck
, libgee
, libgtop
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "monitor";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "stsdc";
    repo = "monitor";
    rev = version;
    sha256 = "sha256-Gin/1vbQbOAKFrjzDuDTNDQlTGTIlb0NUfIWWXd5tQ4=";
    fetchSubmodules = true;
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
    pantheon.wingpanel
    libgee
    libgtop
    libwnck
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
    description = "Manage processes and monitor system resources";
    longDescription = ''
      Manage processes and monitor system resources.
      To use the wingpanel indicator in this application, see the Pantheon
      section in the NixOS manual.
    '';
    homepage = "https://github.com/stsdc/monitor";
    maintainers = with maintainers; [ xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
