{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gtfocli";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "cmd-tools";
    repo = "gtfocli";
    tag = version;
    hash = "sha256-w3x01ZoJHeze0eGyx5jLqWHSd4taS+P+MdVlq2BcI2o=";
  };

  vendorHash = "sha256-FyClL+3fOe56+Y7CSNJtGoJaYnMeo2hoxYNPpg5FQJ8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "GTFO Command Line Interface for search binaries commands to bypass local security restrictions";
    homepage = "https://github.com/cmd-tools/gtfocli";
    changelog = "https://github.com/cmd-tools/gtfocli/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gtfocli";
  };
}
