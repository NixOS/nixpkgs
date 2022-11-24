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
, libgweather
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loupe";
  # latest maeson.build requires gtk4 >=4.9.4
  # and gtk4-sys with feature v4_10 requires gtk4 >= 4.9
  version = "unstable-2023-03-01";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Incubator";
    repo = "loupe";
    rev = "01bebfef384610169d020ea31b083af7cc4eb1db";
    hash = "sha256-FFsE5sXkmPti8hYwKjMo1xwgjep8CzxXZFm32JDYKZc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-a9w6WmTEuuKY956RAhmiCo+ty/9dWjfI6JnXKCSa8JM=";
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
    libgweather
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/Incubator/loupe/";
    description = "A simple image viewer application written with GTK4 and Rust";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.unix;
  };
})
