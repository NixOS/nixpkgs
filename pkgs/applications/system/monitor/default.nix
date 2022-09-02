{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
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
, libhandy
, sassc
, udisks2
, wrapGAppsHook
, libX11
, libXext
, libXNVCtrl
}:

stdenv.mkDerivation rec {
  pname = "monitor";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "stsdc";
    repo = "monitor";
    rev = version;
    sha256 = "sha256-dw1FR9nU8MY6LBL3sF942azeSgKmCntXCk4+nhMb4Wo=";
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
    libhandy
    libwnck
    sassc
    udisks2
    libX11
    libXext
    libXNVCtrl
  ];

  # Force link against Xext, otherwise build fails with:
  # ld: /nix/store/...-libXNVCtrl-495.46/lib/libXNVCtrl.a(NVCtrl.o): undefined reference to symbol 'XextAddDisplay'
  # ld: /nix/store/...-libXext-1.3.4/lib/libXext.so.6: error adding symbols: DSO missing from command line
  # https://github.com/stsdc/monitor/issues/292
  NIX_LDFLAGS = "-lXext";

  mesonFlags = [ "-Dindicator-wingpanel=enabled" ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = gitUpdater {
      inherit pname version;
      ignoredVersions = "ci.*";
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
    license = licenses.gpl3Plus;
    mainProgram = "com.github.stsdc.monitor";
  };
}
