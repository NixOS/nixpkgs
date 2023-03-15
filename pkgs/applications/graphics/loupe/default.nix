{ stdenv
, lib
, fetchFromGitLab
, rustPlatform
, meson
, pkg-config
, gtk4
, itstool
, desktop-file-utils
, ninja
, wrapGAppsHook4
, libadwaita
, gnome
, webp-pixbuf-loader
, gdk-pixbuf
, libgweather
, librsvg
, shared-mime-info
, libheif
, libxml2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loupe";
  version = "unstable-2023-03-14";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Incubator";
    repo = "loupe";
    rev = "889c818c14179e3f4755fb56f38d1af603e009cf";
    hash = "sha256-9FNUAypm2GAd8/deEbNhCV+eIEGxOBCzFyytKaK9dnw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-tUi+y6raAhfG1bvUuSR/MRIax3OhExOBxn8gElLBRfI=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    gtk4
    itstool
    desktop-file-utils # update-desktop-database
    ninja
    wrapGAppsHook4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    libadwaita
    gdk-pixbuf
    libgweather
    librsvg
    shared-mime-info
    libheif
    libxml2
  ];

  # based on eog
  postInstall = ''
    # Pull in WebP support
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
      extraLoaders = [
        librsvg
        webp-pixbuf-loader
      ];
    }}"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/Incubator/loupe/";
    description = "A simple image viewer application written with GTK4 and Rust";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.unix;
  };
})
