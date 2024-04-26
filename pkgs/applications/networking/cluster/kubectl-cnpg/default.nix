{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-pNyXi3IjEMwAUdNzDw8WttQzmtHja2YfTHntowLrQOo=";
  };

  vendorHash = "sha256-3yh6b0dB2JC0t2EwykWiLk6glyKUhTpqmqvfFZ4RekE=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
