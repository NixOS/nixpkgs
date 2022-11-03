{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, updateGolangSysHook
}:

buildGoModule rec {
  pname = "kubeval";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "kubeval";
    rev = "v${version}";
    sha256 = "sha256-pwJOV7V78H2XaMiiJvKMcx0dEwNDrhgFHmCRLAwMirg=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-JeN63M/WGh6sM1zt0rf+Mo3Zb2ckRvS93tgogFWn8AQ=";

  doCheck = false;

  meta = with lib; {
    description = "Validate your Kubernetes configuration files";
    homepage = "https://github.com/instrumenta/kubeval";
    license = licenses.asl20;
    maintainers = with maintainers; [ johanot nicknovitski ];
  };
}
