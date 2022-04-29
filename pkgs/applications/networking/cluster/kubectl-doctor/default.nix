{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-doctor";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "emirozer";
    repo = pname;
    rev = version;
    sha256 = "sha256-yp5OfSDxIASiCgISUVNxfe3dsLukgIoHARVPALIaQfY=";
  };

  vendorSha256 = "sha256-pdg65q7iMkcpFvSVUTa07m5URLQNNEfWQ4mdGu4suBM=";

  postInstall = ''
    mv $out/bin/{cmd,kubectl-doctor}
  '';

  meta = with lib; {
    description = "kubectl cluster triage plugin for k8s";
    homepage = "https://github.com/emirozer/kubectl-doctor";
    changelog = "https://github.com/emirozer/kubectl-doctor/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.zimbatm ];
  };
}
