{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  fetchPnpmDeps,
  installShellFiles,
  pnpm,
  pnpmConfigHook,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "supabase-cli";
  version = "3.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i8pqD32rfGnlCNRrnvaQlbqoKHCzfQpq3S1zB+ln8Q8=";
  };

  pnpmWorkspaces = [ "supabase..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-y9rkFHns3k+/fWBf93cGZMNztn2tibgH0HOIDQNNFkE=";
  };

  nativeBuildInputs = [
    bun
    installShellFiles
    pnpm
    pnpmConfigHook
  ];

  postPatch = ''
    substituteInPlace apps/cli/package.json \
      --replace-fail '"version": "0.0.0-automated"' '"version": "${finalAttrs.version}"'
  '';

  buildPhase = ''
    runHook preBuild
    cd apps/cli
    bun scripts/build-binary.ts
    runHook postBuild
  '';

  # Stripping makes the executable run plain Bun instead of the embedded CLI.
  dontStrip = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckKeepEnvironment = [ "HOME" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 dist/supabase $out/bin/supabase

    installShellCompletion --cmd supabase \
      --bash <($out/bin/supabase completion bash) \
      --fish <($out/bin/supabase completion fish) \
      --zsh <($out/bin/supabase completion zsh)
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    # Fetch versions from GitHub releases to detect pre-releases and
    # avoid updating to them.
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "CLI for interacting with supabase";
    homepage = "https://github.com/supabase/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gerschtli
      kashw2
      yuannan
    ];
    mainProgram = "supabase";
    inherit (bun.meta) platforms;
  };
})
