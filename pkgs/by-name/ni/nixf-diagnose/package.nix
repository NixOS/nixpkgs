{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixf,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixf-diagnose";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "inclyc";
    repo = "nixf-diagnose";
    rev = "ac95d9e0877b1c2b58882d16c7a578b216ffb5b4";
    hash = "sha256-6rqnhkbI1Z9ytsJtfu9AiqEj0dcbEZHw2s5sQe+jQ8Q=";
  };

  env.NIXF_TIDY_PATH = lib.getExe nixf;

  cargoHash = "sha256-LutCktLHpfl5aMvN9RW0IL9nojcq4j2kjc9zfeePCMg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI wrapper for nixf-tidy with fancy diagnostic output";
    mainProgram = "nixf-diagnose";
    homepage = "https://github.com/inclyc/nixf-diagnose";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ inclyc ];
  };
})
