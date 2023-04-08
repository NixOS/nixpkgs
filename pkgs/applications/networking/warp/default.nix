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
, wrapGAppsHook4
, glib
, gtk4
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "warp";
  version = "0.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-c8X0kedfM8DPTEQAbh8cXIfEvxG2cdUD3twVHs0/k7U";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tempfile-3.3.0" = "sha256-zVbGZOEYEmOJGtl5Ko8rYIW9NY16lq5+zMzJ/TSkfsc=";
    };
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
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
    maintainers = with lib.maintainers; [ dotlambda foo-dogsquared ];
    platforms = lib.platforms.linux;
  };
}
