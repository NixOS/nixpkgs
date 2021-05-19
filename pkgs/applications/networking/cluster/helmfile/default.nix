{ lib, buildGoModule, fetchFromGitHub, makeWrapper, writeScript, kubernetes-helm }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.139.3";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-Cg4FFTowrWMDfpaMJwrOSs3ykZxH378OMR+1+vJt5e8=";
  };

  vendorSha256 = "sha256-Hs09CT/KSwYL2AKLseOjWB5Xvvr5TvbzwDywsGQ9kMw=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/roboll/helmfile/pkg/app/version.Version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/helmfile \
      --prefix PATH : ${lib.makeBinPath [ kubernetes-helm ]}
  '';

  passthru.updateScript = writeScript "update-helmfile" ''
    set -eufo pipefail
    latestTag=$(curl -s https://api.github.com/repos/${src.owner}/${src.repo}/releases/latest | jq -r '.tag_name | ltrimstr("v")')
    update-source-version ${pname} "''${latestTag#v}"
  '';

  meta = {
    description = "Deploy Kubernetes Helm charts";
    homepage = "https://github.com/roboll/helmfile";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pneumaticat yurrriq ];
    platforms = lib.platforms.unix;
  };
}
