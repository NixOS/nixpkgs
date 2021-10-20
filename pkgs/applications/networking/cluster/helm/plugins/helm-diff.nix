{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-diff";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "databus23";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-h26EOjKNrlcrs2DAYj0NmDRgNRKozjfw5DtxUgHNTa4=";
  };

  vendorSha256 = "sha256-+n/QBuZqtdgUkaBG7iqSuBfljn+AdEzDoIo5SI8ErQA=";

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
    description = "A Helm plugin that shows a diff";
    inherit (src.meta) homepage;
    license = licenses.apsl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
