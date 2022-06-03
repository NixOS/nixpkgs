{ lib
, stdenv
, fetchFromGitLab
, appstream-glib
, desktop-file-utils
, itstool
, meson
, ninja
, pkg-config
, python3
, rustPlatform
, wrapGAppsHook
, glib
, gtk4
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "warp";
  version = "0.1.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "warp";
    rev = "v${version}";
    hash = "sha256-6KWTjfrJr0QkiYHkwy4IKrzQuVUMHc1yILM7ixHBHSQ=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Xy/tn5iUqwlmztmTmqUbISAk1xu9vkbMk4CvK4j2ttM=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = {
    description = "Fast and secure file transfer";
    homepage = "https://apps.gnome.org/app/app.drey.Warp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}
