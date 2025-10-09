{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "kubectl-df-pv";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "yashbhutwala";
    repo = "kubectl-df-pv";
    rev = "v${version}";
    hash = "sha256-dGWGPamVD/26iEgKQcWGKpFIMMlDivFpD/XzmjCr8pQ=";
  };

  vendorHash = "sha256-J15tCwYiVSPa2hSB3DMFtVW9Uer7pFMCD1OpCobnYMc=";

  meta = {
    description = "df-like utility for persistent volumes on Kubernetes";
    mainProgram = "df-pv";
    homepage = "https://github.com/yashbhutwala/kubectl-df-pv";
    changelog = "https://github.com/yashbhutwala/kubectl-df-pv/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jemand771 ];
  };
}
