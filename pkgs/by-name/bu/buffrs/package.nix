{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "buffrs";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "helsing-ai";
    repo = "buffrs";
    tag = "v${version}";
    hash = "sha256-lqSaXTuIXeuvS01i/35oLUU39FpVEpMoR3OSRstKhjI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3urjpHMW46ZnPMsiaRgRyhFOKA+080MauNESRjf/W1Y=";

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
