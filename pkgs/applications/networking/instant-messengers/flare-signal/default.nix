{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, protobuf
, libsecret
, libadwaita
, rustPlatform
, desktop-file-utils
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "flare";
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "Schmiddiii";
    repo = pname;
    rev = version;
    hash = "sha256-wY95sXWGDjEy8vvP79XliJOn5GQkAvDmOXKmRz0TPEw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-J3MGQlPYGjhZKH599vfW2WhkXx+Tdr53PviiVpye4R0=";
  };

  nativeBuildInputs = [
    desktop-file-utils # for update-desktop-database
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    libadwaita
    libsecret
    protobuf
  ];

  meta = {
    changelog = "https://gitlab.com/Schmiddiii/flare/-/blob/${src.rev}/CHANGELOG.md";
    description = "An unofficial Signal GTK client";
    homepage = "https://gitlab.com/Schmiddiii/flare";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda tomfitzhenry ];
    platforms = lib.platforms.linux;
  };
}
