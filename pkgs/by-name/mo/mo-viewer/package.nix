{
  lib,
  stdenvNoCC,
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  jq,
  pnpmConfigHook,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mo-viewer";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "mo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/dUAz55hsDYV+1rgNN52rdO798SCRyIyHXrL/ZGTwmY=";
  };

  frontend = stdenvNoCC.mkDerivation (finalFrontendAttrs: {
    pname = "${finalAttrs.pname}-frontend";
    inherit (finalAttrs) version src;

    pnpmRoot = "internal/frontend";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalFrontendAttrs) pname version src;
      sourceRoot = "${finalFrontendAttrs.src.name}/internal/frontend";
      pnpm = pnpm_10;
      fetcherVersion = 4;
      hash = "sha256-thlwYvB7y6RFwLknbQt5evF4xQVzllrQqVYDdKSbEUM=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm_10
      pnpmConfigHook
      jq
    ];

    postPatch = ''
      jq 'del(.pnpm.executionEnv)' internal/frontend/package.json > internal/frontend/package.json.tmp
      mv internal/frontend/package.json.tmp internal/frontend/package.json
    '';

    buildPhase = ''
      runHook preBuild
      pnpm -C internal/frontend run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r internal/static/dist $out
      runHook postInstall
    '';
  });

  vendorHash = "sha256-rmtJswO3DWWxpb2uk91aIatc7ugNmsqzwlEeKdX7ITE=";

  preBuild = ''
    cp -r ${finalAttrs.frontend} internal/static/dist
  '';

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k1LoW/mo/version.Revision=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd 'mo' \
      --bash <("$out/bin/mo" completion bash) \
      --zsh <("$out/bin/mo" completion zsh) \
      --fish <("$out/bin/mo" completion fish)
  '';

  doCheck = !stdenvNoCC.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/k1LoW/mo";
    description = "Markdown viewer that opens .md files in a browser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "mo";
  };
})
