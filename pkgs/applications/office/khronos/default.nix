{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, vala
, pkg-config
, desktop-file-utils
, python3
, glib
, gtk4
, json-glib
, libadwaita
, libgee
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "khronos";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "sha256-AETyVCBUuBzHwDgTkGRIokFYwcmXrb/F85J5GEIu4dE=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    json-glib
    libadwaita
    libgee
  ];

  postPatch = ''
    chmod +x build-aux/post_install.py
    patchShebangs build-aux/post_install.py
    # https://github.com/lainsce/khronos/pull/75
    substituteInPlace build-aux/post_install.py \
      --replace 'gtk-update-icon-cache' 'gtk4-update-icon-cache'
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Track each task's time in a simple inobtrusive way";
    homepage = "https://github.com/lainsce/khronos";
    maintainers = with maintainers; [ xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
