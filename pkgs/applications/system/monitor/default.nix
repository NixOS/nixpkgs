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
, curl
, flatpak
, gettext
, glib
, gtk3
, json-glib
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
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "stsdc";
    repo = "monitor";
    rev = version;
    sha256 = "sha256-GUNMA4CRO4cKBjNr7i8yRflstbT8g2ciDHppjUUbAOc=";
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
    curl
    flatpak
    glib
    gtk3
    json-glib
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

    # Alternatively, using pkg-config here should just work.
    substituteInPlace meson.build --replace \
      "meson.get_compiler('c').find_library('libcurl', dirs: vapidir)" \
      "meson.get_compiler('c').find_library('libcurl', dirs: '${curl.out}/lib')"
  '';

  passthru = {
    updateScript = gitUpdater {
      # Upstream frequently tags these to fix CI, which are mostly irrelevant to us.
      ignoredVersions = "-";
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
