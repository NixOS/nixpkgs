{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-diff";
  version = "3.9.2";

  src = fetchFromGitHub {
    owner = "databus23";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4EjvjvW8aal/ekGV0ePevPf30NarrWIh6id30n1r2dE=";
  };

  vendorHash = "sha256-RPb5+tZkOsubOl0YlSXsybmlOtKVbJ97c+f/wiz/gmE=";

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
    description = "A Helm plugin that shows a diff";
    homepage = "https://github.com/databus23/helm-diff";
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
