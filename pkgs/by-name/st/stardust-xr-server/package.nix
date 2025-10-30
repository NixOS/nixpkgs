{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  pkg-config,
  stereokit,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-server";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "server";
    rev = "158e34c01d8300f1c07e66da0a7b00c8bad3378a";
    hash = "sha256-c/+IwLgD+0v7+ePugQoES2Yob2+EtiD5uZWpQTMZ9SY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-0.3.0" = "sha256-FNsjbcdiI46nNSWMd4smn5Lg53UU4NFmCfV8ZfaJLs0=";
      "stardust-xr-0.45.0" = "sha256-FdbtBgvknjGW2MnrS2QMwtTSrRjd+KezC3kY5JqRH2s=";
      "stereokit-macros-0.5.1" = "sha256-QFH+VQkTAEjOswoBxwciQT5NjoQu2lN/J4WA9xXtGwA=";
    };
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    stereokit
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland compositor and display server for 3D applications";
    homepage = "https://stardustxr.org/";
    changelog = "https://github.com/StardustXR/server/releases";
    license = lib.licenses.gpl2Plus;
    mainProgram = "stardust-xr-server";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
