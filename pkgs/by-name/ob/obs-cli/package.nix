{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule rec {
  pname = "obs-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "obs-cli";
    tag = "v${version}";
    hash = "sha256-4tjS+PWyP/T0zs4IGE6VQ5c+3tuqxlBwfpPBVEcim6c=";
  };

  vendorHash = "sha256-tjQOHvmhHyVMqIJQvFaisEqci1wkB4ke/a+GSgwXzCo=";

  proxyVendor = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Command-line remote control for OBS";
    homepage = "https://github.com/muesli/obs-cli";
    changelog = "https://github.com/muesli/obs-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flexiondotorg ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "obs-cli";
  };
}
