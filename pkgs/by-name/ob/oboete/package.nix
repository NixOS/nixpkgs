{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "oboete";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "oboete";
    tag = version;
    hash = "sha256-Xs9o6V/rUtRkUp7F2hJXLz8PP7XWtqx4uaONo3Q23uo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bhSkQcDqYhkRwqLbiOLXprQnMqjDKRetZ97K1ES5hrw=";

  nativeBuildInputs = [ libcosmicAppHook ];

  buildInputs = [ sqlite ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple flashcards application for the COSMIC™ desktop written in Rust";
    homepage = "https://github.com/mariinkys/oboete";
    changelog = "https://github.com/mariinkys/oboete/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
    mainProgram = "oboete";
  };
}
