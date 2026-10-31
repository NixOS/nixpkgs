{
  lib,
  stdenvNoCC,
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
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
    inherit (finalAttrs) version src;

    pnpmRoot = "internal/frontend";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalFrontendAttrs) pname version src;
      sourceRoot = "${finalFrontendAttrs.src.name}/internal/frontend";
      pnpm = pnpm_10;
      fetcherVersion = 4;
      hash = "sha256-EOxHcL6h9vg31jI/DkkiJvdOsl3VyLY31D8jznjrMH8=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm_10
      pnpmConfigHook
    ];

    preBuild = ''
      ln -sf ${lib.getExe nodejs} internal/frontend/node_modules/.bin/node
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
