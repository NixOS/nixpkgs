{ buildGo122Module, fetchFromGitHub, lib }:

buildGo122Module rec {
  pname = "helm-diff";
  version = "3.9.8";

  src = fetchFromGitHub {
    owner = "databus23";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HGQTnvtL9hksy0B9U6jK8kkyoc3g0lmuBRV3vsg9Yao=";
  };

  vendorHash = "sha256-4bYepEVeVg+X0WicktE8BorwgsLGh2cZUn8rgfMExpk=";

  ldflags = [ "-s" "-w" "-X github.com/databus23/helm-diff/v3/cmd.Version=${version}" ];

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/${pname}
    mv $out/bin $out/${pname}/
    mv $out/${pname}/bin/{helm-,}diff
    install -m644 -Dt $out/${pname} plugin.yaml
  '';

  meta = with lib; {
    description = "Helm plugin that shows a diff";
    homepage = "https://github.com/databus23/helm-diff";
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
