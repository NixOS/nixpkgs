{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "buffrs";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "helsing-ai";
    repo = "buffrs";
    tag = "v${version}";
    hash = "sha256-VHzPOFOkwz3QlDt25gBbishM4ujtEPFjA21WuiNVw00=";
  };

  cargoHash = "sha256-/cdBt23VSmwN/C2XdHeeRjUSqLWiEheqVl+hfEDKIP0=";

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
