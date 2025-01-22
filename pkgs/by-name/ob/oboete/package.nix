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
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "oboete";
    tag = version;
    hash = "sha256-W5dd8UNjG2w0N1EngDPK7Q83C2TF9UfW0GGvPaW6nls=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UZUqPITtpHeNrsi6Nao+dfK3ACVJmZIc47aqSbwTemw=";

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
    changelog = "https://github.com/mariinkys/oboete/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
    mainProgram = "oboete";
  };
}
