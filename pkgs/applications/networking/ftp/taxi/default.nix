{ lib
, stdenv
, fetchFromGitHub
, gobject-introspection
, gtk3
, libgee
, libhandy
, libsecret
, libsoup
, meson
, ninja
, nix-update-script
, pantheon
, pkg-config
, python3
, vala
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "taxi";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Alecaddd";
    repo = pname;
    rev = version;
    sha256 = "1a4a14b2d5vqbk56drzbbldp0nngfqhwycpyv8d3svi2nchkvpqa";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libgee
    libhandy
    libsecret
    libsoup
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/Alecaddd/taxi";
    description = "The FTP Client that drives you anywhere";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "com.github.alecaddd.taxi";
  };
}
