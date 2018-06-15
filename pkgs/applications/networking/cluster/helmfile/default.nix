{ lib, buildGoPackage, fetchFromGitHub, ... }:

let version = "0.16.0"; in

buildGoPackage {
  name = "helmfile-${version}";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "12gxlan89h0r83aaacshh58nd1pi26gx5gkna0ksll9wsfvraj4d";
  };

  goPackagePath = "github.com/roboll/helmfile";

  meta = {
    description = "Deploy Kubernetes Helm charts";
    homepage = https://github.com/roboll/helmfile;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pneumaticat ];
    platforms = lib.platforms.unix;
  };
}
