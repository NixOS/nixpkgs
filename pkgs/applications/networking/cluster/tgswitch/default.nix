{ buildGoPackage, lib, fetchFromGitHub }:
buildGoPackage rec {
  pname = "tgswitch";
  version = "0.5.378";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "tgswitch";
    rev = version;
    sha256 = "0q2aqh75acbpkmvkws0rl3d5dzq3sisy637c0x6cnc88h34g3n3i";
  };

  goPackagePath = "github.com/warrensbox/tgswitch";

  meta = with lib; {
    description =
      "A command line tool to switch between different versions of terragrunt";
    homepage = "https://github.com/warrensbox/tgswitch";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
