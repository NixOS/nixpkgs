{ buildGo122Module, fetchFromGitHub, lib }:

buildGo122Module rec {
  pname = "helm-diff";
  version = "3.9.5";

  src = fetchFromGitHub {
    owner = "databus23";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6XkiGSbZzkYnqaHcoZQckADGVcWmSWL87MVzqb98lMQ=";
  };

  vendorHash = "sha256-E0ERop/TBr36sfTKCD+DdZwHSkhYdGmvKoJF2gl3gwE=";

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
