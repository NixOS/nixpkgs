{ buildGoModule, lib, fetchFromGitHub }:
buildGoModule rec {
  pname = "tgswitch";
  version = "0.5.389";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "tgswitch";
    rev = version;
    sha256 = "sha256-6hErfI7LEJFgOoJR8IF9jTSBwqbQYeGiwdeJShqxVQ0=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  # There are many modifications need to be done to make tests run. For example:
  # 1. Network access
  # 2. Operation on `/var/empty` not permitted on macOS
  doCheck= false;

  meta = with lib; {
    description = "A command line tool to switch between different versions of terragrunt";
    homepage = "https://github.com/warrensbox/tgswitch";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}

