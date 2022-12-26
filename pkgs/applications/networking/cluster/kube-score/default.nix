{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kube-score";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "zegl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dKvPLAT9e8gNJkKDF7dQPGLSkv9QUjQklUX8Dm8i33E=";
  };

  vendorHash = "sha256-pcNdszOfsYKiASOUNKflbr89j/wb9ILQvjMJYsiGPWo=";

  meta = with lib; {
    description = "Kubernetes object analysis with recommendations for improved reliability and security";
    homepage = "https://github.com/zegl/kube-score";
    changelog = "https://github.com/zegl/kube-score/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ j4m3s ];
  };
}
