{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buffrs";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "helsing-ai";
    repo = "buffrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IKL8zBDM83TgyYHcGOBn+6nzIo6ywvlZk+G5cBC4ijE=";
  };

  cargoHash = "sha256-Mku0H3fwyxtHgPuJndHA/lcd7/rGVw69+j1GdFt5JyQ=";

  # Disabling tests meant to work over the network, as they will fail
  # inside the builder.
  checkFlags = [
    "--skip=cmd::install::upgrade::fixture"
    "--skip=cmd::publish::lib::fixture"
    "--skip=cmd::publish::local::fixture"
    "--skip=cmd::tuto::fixture"
  ];

  meta = {
    description = "Modern protobuf package management";
    homepage = "https://github.com/helsing-ai/buffrs";
    license = lib.licenses.asl20;
    mainProgram = "buffrs";
    maintainers = with lib.maintainers; [ danilobuerger ];
  };
})
