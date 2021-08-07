{ lib
, stdenv
, fetchFromGitHub
, gobject-introspection
, gtk3
, libgee
, libsecret
, libsoup
, meson
, ninja
, nix-update-script
, pantheon
, pkg-config
, python3
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "taxi";
  version = "0.0.1-unstable=2020-09-03";

  src = fetchFromGitHub {
    owner = "Alecaddd";
    repo = pname;
    rev = "74aade67fd9ba9e5bc10c950ccd8d7e48adc2ea1";
    sha256 = "sha256-S/FeKJxIdA30CpfFVrQsALdq7Gy4F4+P50Ky5tmqKvM=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libgee
    libsecret
    libsoup
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    homepage = "https://github.com/Alecaddd/taxi";
    description = "The FTP Client that drives you anywhere";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ] ++ teams.pantheon.members;
    platforms = platforms.linux;
  };

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };
}
