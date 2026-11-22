{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  __structuredAttrs = true;
  pname = "balena-compose-parser";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "balena-io-modules";
    repo = "balena-compose-parser";
    rev = "v${version}";
    hash = "sha256-q7zwJRvjZLzweXGavjxflX6PV7vJqc1c+ZFmsKj5iwg=";
  };

  modRoot = "lib";
  vendorHash = "sha256-t3snmAQe+rbclrvNjmFl9O9KAc5OFU9zH3r+1+B+JI4=";

  meta = {
    description = "compose-go wrapper for parsing balena-compatible docker-compose.yml files ";
    homepage = "https://github.com/balena-io-modules/balena-compose-parser";
    changelog = "https://github.com/balena-io-modules/balena-compose-parser/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kalebpace
    ];
    mainProgram = "balena-compose-parser";
  };
}
