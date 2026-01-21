{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  pkg-config,
  udev,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-external-monitor-brightness";
  version = "0.0.1-unstable-2025-12-10";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-external-monitor-brightness";
    rev = "1d63ebe422428ae73fd9b7e2eafbb2649539b923";
    hash = "sha256-ytZvjwqroIU5Sx65LPvAmHlcmKrInIyo6psCZjuHYK0=";
  };

  cargoHash = "sha256-ou7iukl1pHMfcJNemwLdZYYxugbJJQ53XpCYowUTj90=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [ udev ];

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
    description = "Applet to control the brightness of external monitors";
    homepage = "https://github.com/cosmic-utils/cosmic-ext-applet-external-monitor-brightness";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-applet-external-monitor-brightness";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
}
