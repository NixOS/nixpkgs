{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  vulkan-loader,
  stdenv,
  wayland,
  nix-update-script,
  testers,
  ringboard,
}:

rustPlatform.buildRustPackage rec {
  pname = "ringboard";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "clipboard-history";
    rev = "refs/tags/${version}";
    hash = "sha256-Jk7PEXfdGKRICX7aC/3Ktkk4OWlT5IGON2Dp/AkUC7A=";
  };

  cargoHash = "sha256-I756jz2jwSXQuRM2el7VS0MCFXWzLCbEwX0HW7Rfnpg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxkbcommon
    vulkan-loader
  ] ++ lib.optionals stdenv.isLinux [ wayland ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion { package = ringboard; };
  };

  meta = {
    description = "a clipboard manager for Linux";
    homepage = "https://github.com/SUPERCILEX/clipboard-history";
    changelog = "https://github.com/SUPERCILEX/clipboard-history/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
    mainProgram = "ringboard";
  };
}
