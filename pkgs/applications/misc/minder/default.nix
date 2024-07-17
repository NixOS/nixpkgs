{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  python3,
  shared-mime-info,
  vala,
  wrapGAppsHook3,
  cairo,
  discount,
  glib,
  gtk3,
  gtksourceview4,
  hicolor-icon-theme, # for setup-hook
  json-glib,
  libarchive,
  libgee,
  libhandy,
  libxml2,
  pantheon,
}:

stdenv.mkDerivation rec {
  pname = "minder";
  version = "1.16.4";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = pname;
    rev = version;
    sha256 = "sha256-1r2PbBYw4mmiScKbX9BGqe4i+emSvismJfPm3opLlOg=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    shared-mime-info
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    discount
    glib
    gtk3
    gtksourceview4
    hicolor-icon-theme
    json-glib
    libarchive
    libgee
    libhandy
    libxml2
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  postFixup = ''
    for x in $out/bin/*; do
      ln -vrs $x "$out/bin/''${x##*.}"
    done
  '';

  meta = with lib; {
    description = "Mind-mapping application for elementary OS";
    homepage = "https://github.com/phase1geo/Minder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ] ++ teams.pantheon.members;
    mainProgram = "com.github.phase1geo.minder";
  };
}
