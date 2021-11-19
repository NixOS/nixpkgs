{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, gtk3
, libgee
, pantheon
}:

stdenv.mkDerivation rec {
  pname = "pantheon-tweaks";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "pantheon-tweaks";
    repo = pname;
    rev = version;
    sha256 = "sha256-2spZ6RQ5PhBNrv/xG1TNbYsJrmuRpaZ72CeH2s8+P8g=";
  };

  patches = [
    ./fix-paths.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    gtk3
    libgee
  ] ++ (with pantheon; [
    elementary-files # settings schemas
    elementary-terminal # settings schemas
    granite
    switchboard
  ]);

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
    description = "Unofficial system settings panel for Pantheon";
    longDescription = ''
      Unofficial system settings panel for Pantheon
      that lets you easily and safely customise your desktop's appearance.
      Use programs.pantheon-tweaks.enable to add this to your switchboard.
    '';
    homepage = "https://github.com/pantheon-tweaks/pantheon-tweaks";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
