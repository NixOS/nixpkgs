{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  autoPatchelfHook,
  just,
  pkg-config,
  wrapGAppsHook3,

  # buildInputs
  libxkbcommon,
  openssl,
  vulkan-loader,
  wayland,
  nix-update-script,

  cosmic-icons,
}:

rustPlatform.buildRustPackage rec {
  pname = "forecast";
  version = "0-unstable-2024-09-23";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "forecast";
    rev = "d3c274932847aa101fb7aacf1d01ded265b6fad4";
    hash = "sha256-6hlh9T0h1Yi8io2sMU/r8uMtP6isH6JJxE5LvZrj9Cs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-config-0.1.0" = "sha256-zamYPvxmIqh4IT4G+aqceP1mXNNBA1TAcJwAtjlbYAU=";
      "cosmic-text-0.12.1" = "sha256-5Gk220HTiHuxDvyqwz1Dwr+BaLvH/6X7M14IirQzcsE=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [
    autoPatchelfHook
    just
    pkg-config
    wrapGAppsHook3
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  buildInputs = [
    libxkbcommon
    openssl
    vulkan-loader
    wayland
  ];

  env = {
    # COSMIC applications now uses vergen for the About page
    VERGEN_GIT_COMMIT_DATE = "1970-01-01";
    VERGEN_GIT_SHA = src.rev;
  };

  runtimeDependencies = [
    libxkbcommon
    wayland
  ];

  postFixup = ''
    wrapProgram $out/bin/cosmic-ext-forecast \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share"
  '';

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-forecast"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Weather app written in rust and libcosmic";
    homepage = "https://github.com/cosmic-utils/forecast";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-forecast";
  };
}
