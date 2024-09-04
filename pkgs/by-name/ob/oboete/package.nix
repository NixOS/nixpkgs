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
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "oboete";
    rev = "refs/tags/${version}";
    hash = "sha256-y3lHiAIhIt5XL/88HBuCqVQlRzNcw9VAKjqgQJmyziU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-config-0.1.0" = "sha256-p/1ABYyXGSr34ZC7ozu2syBjkmElA9oI2bzyWhaxKnc=";
      "cosmic-settings-daemon-0.1.0" = "sha256-+1XB7r45Uc71fLnNR4U0DUF2EB8uzKeE4HIrdvKhFXo=";
      "cosmic-text-0.12.0" = "sha256-VUUCcW5XnkmCB8cQ5t2xT70wVD5WKXEOPNgNd2xod2A=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

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
