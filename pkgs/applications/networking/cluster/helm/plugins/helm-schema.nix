{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "helm-schema";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "losisin";
    repo = "helm-values-schema-json";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q5A+tCnuHTtUyejP4flID7XhsoBfWGge2jCgsL0uEOc=";
  };

  vendorHash = "sha256-xmj2i1WNI/9ItbxRk8mPIygjq83xuvNu6THyPqZsysY=";

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
    install -D plugin.complete -t $out/helm-schema/
    install -m644 plugin.yaml -t $out/helm-schema/
    mv $out/bin/{helm-values-schema-json,schema}
    mv $out/bin $out/helm-schema
  '';

  # Unit tests try to open web server on port 0
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/helm-schema/bin/schema";
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
