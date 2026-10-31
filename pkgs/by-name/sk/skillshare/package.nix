{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  versionCheckHook,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "skillshare";
  version = "0.27.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "runkids";
    repo = "skillshare";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FBWMP8/UHFH/yFEK2mg1gIwgbZ7/S+m0RHGSkm2ORAM=";
  };

  vendorHash = "sha256-vZxkLUP6E+tyat87VBpW3kr+JtXJizTHmEkiJDoZzbg=";

  subPackages = [ "cmd/skillshare" ];

  # Same flags as upstream's .goreleaser.yaml. The web UI is not embedded:
  # the binary downloads it to its cache on first `skillshare ui`.
  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # Several tests shell out to `git init` / `git commit` in a temp HOME.
  nativeCheckInputs = [ gitMinimal ];
  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name nixbld
    git config --global user.email nixbld@localhost
  '';

  # Installing, syncing, pushing and pulling skills all shell out to git.
  postInstall = ''
    wrapProgram $out/bin/skillshare \
      --suffix PATH : ${lib.makeBinPath [ gitMinimal ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd skillshare \
      --bash <($out/bin/skillshare completion bash) \
      --fish <($out/bin/skillshare completion fish) \
      --zsh <($out/bin/skillshare completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    description = "Sync skills, agents, MCP servers and plugins across AI CLI tools from a single source";
    homepage = "https://github.com/runkids/skillshare";
    changelog = "https://github.com/runkids/skillshare/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ManUtopiK ];
    mainProgram = "skillshare";
    platforms = lib.platforms.unix;
  };
})
