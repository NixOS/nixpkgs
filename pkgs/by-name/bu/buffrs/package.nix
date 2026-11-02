{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buffrs";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "helsing-ai";
    repo = "buffrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AWAqSl7K9B3XFt4+EeyE6PqY/Jt+A187zkdYv1JFlHw=";
  };

  cargoHash = "sha256-+U15/T4yk5VK39UfoI9dIwlkxPNuCkwmAwRThTnUva0=";

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
