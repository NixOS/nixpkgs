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
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "oboete";
    tag = version;
    hash = "sha256-tQn3ihGHkR91zNtBIiyyIEEo21Q0ZSKLEaV/3UI9pwU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-91JMgdpMXL0a7oZXAG5xgiulOIyVXQ5x09wN3XDeSy0=";

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
    description = "Simple flashcards application for the COSMIC™ desktop written in Rust";
    homepage = "https://github.com/mariinkys/oboete";
    changelog = "https://github.com/mariinkys/oboete/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
    mainProgram = "oboete";
  };
}
