{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-mKQuHswnoxgqQOCiQFbibg6MqACOxM73XngQai6s6To=";
  };

  vendorHash = "sha256-SCeKoxI1zFzSwLAdAa1YI3DiyfK/uOk7CmWwQWVeF7g=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
