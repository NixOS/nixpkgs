{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "pachyderm-${version}";
  version = "1.4.6";
  rev = "v${version}";

  goPackagePath = "github.com/pachyderm/pachyderm";
  subPackages = [ "src/server/cmd/pachctl" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "pachyderm";
    repo = "pachyderm";
    sha256 = "1fivihn9s04lmzdiwg0f05qm708fb14xy81pbc31wxdyjw28m8ns";
  };

  meta = with lib; {
    description = "Containerized Data Analytics";
    homepage = https://github.com/pachyderm/pachyderm;
    license = licenses.asl20;
    maintainers = with maintainers; [offline];
  };
}
