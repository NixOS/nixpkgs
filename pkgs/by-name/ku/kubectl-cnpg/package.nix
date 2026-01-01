{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
<<<<<<< HEAD
  version = "1.28.0";
=======
  version = "1.27.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uIIy4zSf6ply859aHVvlujqBWpN18FLZh+Vye3fbSoY=";
  };

  vendorHash = "sha256-Hl7cYZbs+rDS2+1ojgCUhLfBVGQ+ZhAApRczkUYOwVY=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ devusb ];
=======
    hash = "sha256-iEia3g3nxnVm4q5lpV9SFOSKgHJsZ7jdqE73vA2bPpI=";
  };

  vendorHash = "sha256-nbUaSTmhAViwkguMsgIp3lh2JVe7ZTwBTM7oE1aIulk=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
