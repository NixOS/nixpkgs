{ lib
, stdenv
, fetchFromGitLab
, appstream-glib
, cargo
, desktop-file-utils
, itstool
, meson
, ninja
, pkg-config
, python3
, rustPlatform
, rustc
, wrapGAppsHook4
, glib
, gtk4
, libadwaita
, Security
, Foundation
}:

stdenv.mkDerivation rec {
  pname = "warp";
  version = "0.6.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pntHIY0cScDKhWR6kXp6YrEbBQiQjUId3MrJzy5l+K8=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Go/a7aVHF1Yt3yIccKJIVeFy5rckXhSKfd13hdhlLUQ=";
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
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    Foundation
  ];

  meta = {
    description = "Fast and secure file transfer";
    homepage = "https://apps.gnome.org/Warp/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda foo-dogsquared ];
    platforms = lib.platforms.all;
    mainProgram = "warp";
  };
}
