{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "kubectl-df-pv";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "yashbhutwala";
    repo = "kubectl-df-pv";
    rev = "v${version}";
    hash = "sha256-FxKqkxLMNfCXuahKTMod6kWKZ/ucYeIEFcS8BmpbLWg=";
  };

  vendorHash = "sha256-YkDPgN7jBvYveiyU8N+3Ia52SEmlzC0TGBQjUuIAaw0=";

  meta = {
    description = "df (disk free)-like utility for persistent volumes on kubernetes";
    mainProgram = "df-pv";
    homepage = "https://github.com/yashbhutwala/kubectl-df-pv";
    changelog = "https://github.com/yashbhutwala/kubectl-df-pv/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jemand771 ];
  };
}
