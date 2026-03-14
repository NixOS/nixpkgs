{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "helm-schema-gen";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "dadav";
    repo = "helm-schema";
    tag = "${finalAttrs.version}";
    hash = "sha256-jQ0jTv8e6JLoN/HAK55aQfLGRUVTOklJviAr1EgptQk=";
  };

  vendorHash = "sha256-JV9/za2NeRmWTLrP9Urr5Ak/Am85uFTq+hFgTurtPUU=";

  subPackages = [ "cmd/helm-schema" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/helm-schema-gen
    mv $out/bin $out/helm-schema-gen/
    install -m644 -Dt $out/helm-schema-gen plugin.yaml

    mkdir -p $out/bin
    ln -s $out/helm-schema-gen/bin/helm-schema $out/bin/helm-schema-gen
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/helm-schema-gen";
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for generating JSON schemas from Helm chart values";
    longDescription = ''
      Helm plugin and standalone tool that generates JSON schemas from Helm
      chart values. Supports custom annotations, dependency handling, and
      helm-docs compatibility. Enables IDE validation and autocomplete for
      Helm values files.
    '';
    homepage = "https://github.com/dadav/helm-schema";
    changelog = "https://github.com/dadav/helm-schema/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ojsef39 ];
    mainProgram = "helm-schema-gen";
  };
})
