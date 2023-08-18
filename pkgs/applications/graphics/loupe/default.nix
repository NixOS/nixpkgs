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
  version = "45.beta.1";

  src = fetchurl {
    url = "mirror://gnome/sources/loupe/${lib.versions.major version}/loupe-${version}.tar.xz";
    hash = "sha256-uCvnrFgGksbPVjtX/+2X5KzlRYWzH9M0BKQGplB3Rr8=";
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

  postPatch = ''
    # Nothing is installed to $datadir/glib-2.0/schemas.
    # https://gitlab.gnome.org/GNOME/loupe/-/merge_requests/280
    substituteInPlace meson.build --replace \
      "glib_compile_schemas: true," "glib_compile_schemas: false,"
  '';

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
