{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "helm-diff";
  version = "3.15.13";

  src = fetchFromGitHub {
    owner = "databus23";
    repo = "helm-diff";
    rev = "v${version}";
    hash = "sha256-/Wu8OszNOhv1I7NA9vvwO0IB957sxnh8NGzo3cEjE/s=";
  };

  vendorHash = "sha256-lzR/vuXJgoo2VpVeV/mLTmBi9LJepGA/uxtCg3KK9LI=";

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
