{ stdenv
, lib
, fetchurl
, cargo
, desktop-file-utils
, itstool
, meson
, ninja
, pkg-config
, rustc
, wrapGAppsHook4
, gtk4
, lcms2
, libadwaita
, libgweather
, glycin-loaders
, gnome
}:

stdenv.mkDerivation rec {
  pname = "loupe";
  version = "45.0";

  src = fetchurl {
    url = "mirror://gnome/sources/loupe/${lib.versions.major version}/loupe-${version}.tar.xz";
    hash = "sha256-TWSP47a/6lUpmGWW1qRQp205fx3wqNju3s8BBAYiFHE=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    lcms2
    libadwaita
    libgweather
  ];

  preFixup = ''
    # Needed for the glycin crate to find loaders.
    # https://gitlab.gnome.org/sophie-h/glycin/-/blob/0.1.beta.2/glycin/src/config.rs#L44
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "loupe";
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/loupe";
    description = "A simple image viewer application written with GTK4 and Rust";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jk ] ++ teams.gnome.members;
    platforms = platforms.unix;
    mainProgram = "loupe";
  };
}
