{
  lib,
  stdenvNoCC,
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
  applyPatches,
  jq,
  yq,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "mo-viewer";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "mo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EaL0dU4rR3Kg5tuOHgu3374EACqr4X9zrrJ+tn0LEbw=";
  };

  frontend = stdenvNoCC.mkDerivation (finalFrontendAttrs: {
    pname = "${finalAttrs.pname}-frontend";
    inherit (finalAttrs) version;

    src = applyPatches {
      inherit (finalAttrs) src;
      nativeBuildInputs = [
        jq
        yq
      ];
      postPatch = ''
        pushd internal/frontend
        jq 'del(.devEngines.runtime)' package.json > package.json.tmp
        mv package.json.tmp package.json
        yq -yi '
          del(.importers["."].devDependencies.node)
          | del(.packages | .[keys[] | select(startswith("node@runtime:"))])
          | del(.snapshots | .[keys[] | select(startswith("node@runtime:"))])
        ' pnpm-lock.yaml
        popd
      '';
    };

    pnpmRoot = "internal/frontend";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalFrontendAttrs) pname version src;
      sourceRoot = "${finalFrontendAttrs.src.name}/internal/frontend";
      pnpm = pnpm_10;
      fetcherVersion = 4;
      hash = "sha256-onQyMpGWs+FQbKoPQQrm62ZcenKc7O6Pqiu2LqvZgpI=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm_10
      pnpmConfigHook
    ];

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

  vendorHash = "sha256-b9jVZg4PByGyF/dLn9w2PT5lHsQMLdnx4jGloRj8EJo=";

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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "frontend"
    ];
  };

  meta = {
    homepage = "https://github.com/k1LoW/mo";
    description = "Markdown viewer that opens .md files in a browser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "mo";
  };
})
