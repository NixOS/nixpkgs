{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "helm-schema-dadav";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "dadav";
    repo = "helm-schema";
    tag = finalAttrs.version;
    hash = "sha256-nN+i0HrgybS/fyhyEaAb/VH24noyV7dE4svrEhH8cs8=";
  };

  vendorHash = "sha256-JV9/za2NeRmWTLrP9Urr5Ak/Am85uFTq+hFgTurtPUU=";

  subPackages = [ "cmd/helm-schema" ];

  env.CGO_ENABLED = 0;

  postPatch = ''
    # Remove the install and upgrade hooks
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/${finalAttrs.pname}
    mv $out/bin $out/${finalAttrs.pname}/
    install -m644 -Dt $out/${finalAttrs.pname} plugin.yaml
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/${finalAttrs.pname}/bin/helm-schema";

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "helm-schema";
    description = "Helm plugin for generating JSON schemas from Helm charts values files";
    homepage = "https://github.com/dadav/helm-schema";
    changelog = "https://github.com/dadav/helm-schema/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
  };
})
