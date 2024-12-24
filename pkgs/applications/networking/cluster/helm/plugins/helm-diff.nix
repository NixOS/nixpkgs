{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "helm-diff";
  version = "3.9.13";

  src = fetchFromGitHub {
    owner = "databus23";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-676xMnedfGF3aVub78eQo2KYJgJLxKg9g3Nm6D9lYA0=";
  };

  vendorHash = "sha256-qfdxEXiNJlaJPzpwY4GY+mYZAxjkMJyZO8PgcqJCPos=";

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

  meta = with lib; {
    description = "Helm plugin that shows a diff";
    homepage = "https://github.com/databus23/helm-diff";
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
