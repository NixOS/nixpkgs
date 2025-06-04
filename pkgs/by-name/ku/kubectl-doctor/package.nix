{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "kubectl-doctor";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "emirozer";
    repo = "kubectl-doctor";
    rev = version;
    hash = "sha256-yp5OfSDxIASiCgISUVNxfe3dsLukgIoHARVPALIaQfY=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/emirozer/kubectl-doctor/pull/21
      name = "go-1.19-client-go-0.25.patch";
      url = "https://github.com/emirozer/kubectl-doctor/commit/a987ef58063e305409034af280d688a11682dbb9.patch";
      hash = "sha256-NQd/WxUfYwBDowhnoUWaOV8k7msiOhff3Bjux+a9R9E=";
    })
  ];

  vendorHash = "sha256-qhffg/s1RZFNW0nHLbJ89yqLzdC72ARXdbSfMLJK2pQ=";

  postInstall = ''
    mv $out/bin/{cmd,kubectl-doctor}
  '';

  meta = {
    description = "kubectl cluster triage plugin for k8s";
    mainProgram = "kubectl-doctor";
    homepage = "https://github.com/emirozer/kubectl-doctor";
    changelog = "https://github.com/emirozer/kubectl-doctor/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.zimbatm ];
  };
}
