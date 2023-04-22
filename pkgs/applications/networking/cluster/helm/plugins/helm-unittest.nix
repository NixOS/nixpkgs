{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "helm-unittest";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "helm-unittest";
    repo = "helm-unittest";
    rev = "v${version}";
    hash = "sha256-zm0BFedadP+5AaPVijSJKxC8g9zoXzi+f+dG9cxTBpo=";
  };

  vendorSha256 = "sha256-MrDqk2XGjbUw0xRMZmLnCkoQTVHvVwUgZfKoohie9BQ=";

  subPackage = [ "cmd/${pname}" ];

  # Remove hooks.
  postPatch = ''
    sed -e '/^hooks:/,+2 d' -i plugin.yaml
  '';

  CGO_ENABLED = 0;

  ldflags = [ "-X main.version=${version}" "-extldflags '-static'" ];

  postInstall = ''
    install -Dm644 plugin.yaml $out/${pname}/plugin.yaml
    mv $out/bin/${pname} $out/${pname}/untt
  '';

  meta = with lib; {
    description = "BDD styled unit test framework for Kubernetes Helm charts as a Helm plugin";
    homepage = "https://github.com/helm-unittest/helm-unittest";
    license = licenses.mit;
    maintainers = with maintainers; [ ernestre ];
  };
}
