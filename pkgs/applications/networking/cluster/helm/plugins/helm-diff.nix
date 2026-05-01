{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "helm-diff";
  version = "3.15.6";

  src = fetchFromGitHub {
    owner = "databus23";
    repo = "helm-diff";
    rev = "v${version}";
    hash = "sha256-DGJtvCQ3WGY/Aajrpn/QUQebjb0K9otyRtqCZa4iqMY=";
  };

  vendorHash = "sha256-psfNtI5rf5B/dQKPjPPwuG14Z/hsJWmuL5JiLuux6ng=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/databus23/helm-diff/v3/cmd.Version=${version}"
  ];

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

  meta = {
    description = "Helm plugin that shows a diff";
    homepage = "https://github.com/databus23/helm-diff";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yurrriq ];
  };
}
