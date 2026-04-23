{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "lakefs";
  version = "1.79.0";

  src = fetchFromGitHub {
    owner = "treeverse";
    repo = "lakeFS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UL9JvrNvtHADI0POguLXMDNNvO1oKHXXwfr8tOyvFYc=";
  };

  webui = buildNpmPackage {
    pname = "lakefs-webui";

    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/webui";

    nodejs = nodejs_22;

    npmDepsHash = "sha256-Z9oOIKK6Hm/Bg3E37f4FqFFL1exMIf0KNEHQXIyox+Q=";

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };

  subPackages = [ "cmd/lakefs" ];
  proxyVendor = true;
  vendorHash = "sha256-6XOJBDdAERD6mcneQ7UFqAPGq+pXroNlzQGNvycpVBc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/treeverse/lakefs/pkg/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    mkdir -p webui/dist
    cp -r ${finalAttrs.webui}/* webui/dist/
    go generate ./pkg/api/apigen ./pkg/auth ./pkg/authentication
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lakefs \
      --bash <($out/bin/lakefs completion bash) \
      --fish <($out/bin/lakefs completion fish) \
      --zsh <($out/bin/lakefs completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Data version control for object storage (Git for data)";
    homepage = "https://lakefs.io/";
    downloadPage = "https://github.com/treeverse/lakeFS";
    changelog = "https://github.com/treeverse/lakeFS/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "lakefs";
    platforms = lib.platforms.unix;
  };
})
