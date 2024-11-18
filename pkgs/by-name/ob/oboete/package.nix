{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  libxkbcommon,
  sqlite,
  vulkan-loader,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "oboete";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "oboete";
    rev = "refs/tags/${version}";
    hash = "sha256-tiYZ8xMIxMvRdQCf9+LI2B1lXbJz7MFyyeAOkJR+8Vk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DIL+Bju6c31Y5TLuds7lyx6PHZnNqedgMEAj1O+8uRI=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libxkbcommon
    sqlite
    vulkan-loader
    wayland
  ];

  postFixup = ''
    wrapProgram $out/bin/oboete \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxkbcommon
          wayland
        ]
      }"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A simple flashcards application for the COSMIC™ desktop written in Rust";
    homepage = "https://github.com/mariinkys/oboete";
    changelog = "https://github.com/mariinkys/oboete/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
    mainProgram = "oboete";
  };
}
