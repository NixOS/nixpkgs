{ stdenv
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
, bamf
, libwnck3
, libgee
, libgtop
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "monitor";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "stsdc";
    repo = "monitor";
    rev = version;
    sha256 = "111g2f3y5lmz91m755jz0x8yx5cx9ym484gch8wcv80dmr7ilb1y";
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
    bamf
    glib
    gtk3
    pantheon.granite
    pantheon.wingpanel
    libgee
    libgtop
    libwnck3
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

  meta = with stdenv.lib; {
    description = "Manage processes and monitor system resources";
    longDescription = ''
      Manage processes and monitor system resources.
      To use the wingpanel indicator in this application, see the Pantheon
      section in the NixOS manual.
    '';
    homepage = "https://github.com/stsdc/monitor";
    maintainers = with maintainers; [ xiorcale ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
