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

  useFetchCargoVendor = true;
  cargoHash = "sha256-f8lu1gqMK+EDn1AHbnBDpPcdurpxr/fbfBSBIU8AQr8=";

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
