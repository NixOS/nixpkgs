{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  libsecret,
  libxkbcommon,
  openssl,
  pango,
  sqlite,
  vulkan-loader,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tasks";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "edfloreshz";
    repo = "tasks";
    rev = "refs/tags/${version}";
    hash = "sha256-0bXzeKnJ5MIl7vCo+7kyXm3L6QrCdm5sPreca1SPi8U=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-temNg+RdvquSLAdkwU5b6dtu9vZkXjnDASS/eJo2rz8=";
      "cosmic-config-0.1.0" = "sha256-dYxBp/2JkgFUtkcfzQieHS7MPf6GoOIxuCN/8AZraio=";
      "cosmic-text-0.11.2" = "sha256-O8l3Auo+7/aqPYvWQXpOdrVHHdjc1fjoU1nFxqdiZ5I=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-MqzynFCZvzVg9/Ry/zrbH5R6//erlZV+nmQ2St63Wnc=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  # COSMIC applications now uses vergen for the About page
  # Update the COMMIT_DATE to match when the commit was made
  env.VERGEN_GIT_COMMIT_DATE = "2024-07-03";
  env.VERGEN_GIT_SHA = "0e8c728c88a9cac1bac130eb083ca0fe58c7121d";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    libsecret
    libxkbcommon
    openssl
    pango
    sqlite
    vulkan-loader
    wayland
  ];

  postFixup = ''
    wrapProgram $out/bin/tasks \
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

  meta = with lib; {
    description = "Simple task management application for the COSMIC desktop";
    homepage = "https://github.com/edfloreshz/tasks";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = platforms.linux;
    mainProgram = "tasks";
  };
}
