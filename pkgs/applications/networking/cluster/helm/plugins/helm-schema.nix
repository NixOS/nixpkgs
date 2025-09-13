{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "helm-schema";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "losisin";
    repo = "helm-values-schema-json";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dttUbP+G2q+IJwoYReSfJVnc/Dix3Bk0H0EkuCuU9Ko=";
  };

  vendorHash = "sha256-+Idcps9Z/56rvlSYVX8cw4Rbg/2Kt9bzhwtN3clQ3XY=";

  ldflags = [
    "-s"
    "-w"
    "-X 'main.Version=v${finalAttrs.version}'"
  ];

  postPatch = ''
    # Remove the install and upgrade hooks
    sed -i '/^hooks:/,+2 d' plugin.yaml

    substituteInPlace {plugin.yaml,plugin.complete} \
      --replace-fail '$HELM_PLUGIN_DIR' '${placeholder "out"}/${finalAttrs.pname}/bin'
  '';

  postInstall = ''
    install -D plugin.complete --target-directory=$out/${finalAttrs.pname}
    install --mode=644 plugin.yaml --target-directory=$out/${finalAttrs.pname}
    mv $out/bin/{helm-values-schema-json,schema}
    mv $out/bin $out/${finalAttrs.pname}
  '';

  # Unit tests try to open web server on port 0
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/${finalAttrs.pname}/bin/schema";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "schema";
    description = "Helm plugin for generating values.schema.json from multiple values files";
    longDescription = ''
      Helm plugin for generating `values.schema.json` from single or
      multiple values files. Schema can be enriched by reading
      annotations from comments. Works only with Helm3 charts.
    '';
    homepage = "https://github.com/losisin/helm-values-schema-json";
    changelog = "https://github.com/losisin/helm-values-schema-json/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ applejag ];
    license = lib.licenses.mit;
  };
})
