{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "buffrs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "helsing-ai";
    repo = "buffrs";
    tag = "v${version}";
    hash = "sha256-c9GjSqVp2wEFgoy8j+Gy5FA3SG4JYEfeSwPWjW81w3Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-E7kskULt2eOY+mZjh6jAftj8ciExUF7d1z1pePTBzvQ=";

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
}
