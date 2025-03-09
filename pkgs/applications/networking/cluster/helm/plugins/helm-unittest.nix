{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-unittest";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OXl3Ax/sqCNcj2uDb0VctJ6Njrd5blkFuur6FT9HOl4=";
  };

  vendorHash = "sha256-i9H65843XynaaNQLIQkBcgDsjnft3nxz6eWdZM9Dn9U=";

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/${pname}
    mv $out/bin/helm-unittest $out/${pname}/untt
    rmdir $out/bin
    install -m644 -Dt $out/${pname} plugin.yaml
  '';

  meta = with lib; {
    description = "BDD styled unit test framework for Kubernetes Helm charts as a Helm plugin";
    homepage = "https://github.com/helm-unittest/helm-unittest";
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}
