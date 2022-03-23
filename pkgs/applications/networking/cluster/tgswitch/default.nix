{ buildGoPackage, lib, fetchFromGitHub }:
buildGoPackage rec {
  pname = "tgswitch";
  version = "0.5.389";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "tgswitch";
    rev = version;
    sha256 = "sha256-6hErfI7LEJFgOoJR8IF9jTSBwqbQYeGiwdeJShqxVQ0=";
  };

  goPackagePath = "github.com/warrensbox/tgswitch";

  meta = with lib; {
    description = "A command line tool to switch between different versions of terragrunt";
    homepage = "https://github.com/warrensbox/tgswitch";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
