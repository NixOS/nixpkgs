{ lib, stdenv, fetchFromGitHub, nix-update-script, pantheon, pkg-config, meson, ninja, python3, vala
, gtk3, libgee, libsoup, libsecret, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "taxi";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "Alecaddd";
    repo = pname;
    rev = "v${version}";
    sha256 = "01c552w68576pnsyqbwy3hjhbww6vys3r3s0wxjdiscjqj1aawqg";
  };

  nativeBuildInputs = [
    vala
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    pantheon.granite
    libgee
    gtk3
    libsecret
    libsoup
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
    description = "The FTP Client that drives you anywhere";
    homepage    = "https://github.com/Alecaddd/taxi";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms   = platforms.linux;
  };
}
