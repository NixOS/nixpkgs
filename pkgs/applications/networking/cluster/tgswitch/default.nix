{ buildGoPackage, lib, fetchFromGitHub }:
buildGoPackage rec {
  pname = "tgswitch";
  version = "0.5.382";

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "tgswitch";
    rev = version;
    sha256 = "sha256-DbPf1o1XlXLpuYSrNMRwHRqi/urQhSfzPW5BPIvZC/Y=";
  };

  goPackagePath = "github.com/warrensbox/tgswitch";

  meta = with lib; {
    description = "A command line tool to switch between different versions of terragrunt";
    homepage = "https://github.com/warrensbox/tgswitch";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
