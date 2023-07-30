{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.20.2";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-JkvaFhzazvuqRJ6ertwMQhp+H2zsjRGA23XbvLCIYg0=";
  };

  vendorHash = "sha256-unOPTQeJW9rUOpZh7gTjD8IZDh4wi04oBAfDO5juJf8=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
