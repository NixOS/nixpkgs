{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  openssl,
  libgit2,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bounty";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "ghbountybot";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/lKjgrtxjB/VrADfk0k/XilzBpc6i5QNdcysqSbjG4c=";
  };

  cargoHash = "sha256-aYhh7IHPNWFKSYz45KrWIDQMn96p/cHsO/iOk+OhyA4=";

  doCheck = true;

  # libgit2-sys 0.16 needs libgit2 1.7, nixpkgs has 1.9: use the bundled copy
  preBuild = ''
    export LIBGIT2_NO_VENDOR=0
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    libgit2
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for bountybot.dev";
    homepage = "https://github.com/ghbountybot/cli";
    changelog = "https://github.com/ghbountybot/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andrewgazelka ];
    mainProgram = "bounty";
  };
})
