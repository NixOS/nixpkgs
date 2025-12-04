{
 buildGoModule,
 fetchFromGitHub,
 lib,
}:

buildGoModule rec {
  pname = "helm-values-schema-json";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "losisin";
    repo = "helm-values-schema-json";
    tag = "v${version}";
    hash = "sha256-F4tfPZnvvagWEO25JOjtYPYDn+8k6sRH0k1UvHIQRzg=";
  };

  vendorHash = "sha256-2HnbASIZqOPM9WOlZeEQKYbkBHXBjV0JaeKKYAAwQ3w=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/losisin/helm-values-schema-json/v2/cmd.Version=${version}"
  ];

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/helm-schema
    mv $out/bin $out/helm-schema/
    mv $out/helm-schema/bin/{helm-values-schema-json,../schema}
    install -m644 -Dt $out/helm-schema plugin.yaml
    install -m644 -Dt $out/helm-schema plugin.complete
  '';

  meta = {
    description = "Helm plugin for generating values.schema.json from multiple values files";
    homepage = "https://github.com/losisin/helm-values-schema-json";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scout3r ];
  };
}
