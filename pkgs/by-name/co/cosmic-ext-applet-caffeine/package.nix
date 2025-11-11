{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-caffeine";
  version = "0-unstable-2025-10-29";

  src = fetchFromGitHub {
    owner = "tropicbliss";
    repo = "cosmic-ext-applet-caffeine";
    rev = "5eeb6e505eba172fbfee6b9551df8f8a3702213e";
    hash = "sha256-sTvP62oQknRzuc3qQqUAK70uS2MqXl8lAF27V0To8NM=";
  };

  cargoHash = "sha256-89/0XEdQ7MCycAkHhTkA5FCj/eKVLgWDhljKB/Lo4+4=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-caffeine"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Caffeine Applet for the COSMIC desktop";
    homepage = "https://github.com/tropicbliss/cosmic-ext-applet-caffeine";
    license = lib.licenses.gpl2Only;
    mainProgram = "cosmic-ext-applet-caffeine";
    maintainers = [ lib.maintainers.HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
}
