{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-sysinfo";
  version = "0-unstable-2026-07-04";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-sysinfo";
    rev = "f00dfa49568f8e9d97cd109fa67045ddc6df78d7";
    hash = "sha256-e/dmBJik953u1JSQwQ+n9A3jTVmcefKSkF+EmXhg73o=";
  };

  cargoHash = "sha256-KVnvyiF2rXb9gio3o+dE9w/zZ5gcad1uEbWHMBC3yDc=";

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
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Simple system info applet for COSMIC";
    homepage = "https://github.com/cosmic-utils/cosmic-ext-applet-sysinfo";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-applet-sysinfo";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
}
