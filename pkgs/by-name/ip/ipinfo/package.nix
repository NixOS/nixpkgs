{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ipinfo";
  version = "3.3.4";

  src = fetchFromGitHub {
    owner = "ipinfo";
    repo = "cli";
    tag = "${pname}-${version}";
    hash = "sha256-tE174q8eV37N5+Vh/dNb82iM5X1HEk06ObmzuJw+dQs=";
  };

  vendorHash = null;

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Command Line Interface for the IPinfo API";
    homepage = "https://github.com/ipinfo/cli";
    changelog = "https://github.com/ipinfo/cli/releases/tag/ipinfo-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
