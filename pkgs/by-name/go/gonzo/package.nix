{
  stdenv,
  lib,
  go,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:
let
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "control-theory";
    repo = "gonzo";
    tag = "v${version}";
    hash = "sha256-N38gBEe2VZiUtnffzROv9GAwXp0lMyaNj/ywtNlbmjY=";
  };

  webui = buildNpmPackage {
    pname = "gonzo-ui";
    inherit version src;
    sourceRoot = "${src.name}/web";
    npmDepsHash = "sha256-eRI5m1Bz1tcA5CYsLbe2K21EXO3ycRKcAngNm2jIvc0=";

    installPhase = ''
      mkdir -p $out/share
      mv dist $out/share/
    '';
  };
in

buildGoModule (finalAttrs: {
  pname = "gonzo";
  inherit version src;

  __structuredAttrs = true;

  vendorHash = "sha256-8ATB57qiEc6ANBrt1mbqtsFQlIO9p3b4qdZX2ua7EMY=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.tag}"
    "-X=main.buildTime=1970-01-01T00:00:00Z"
    "-X=main.goVersion=${lib.getVersion go}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    # Ensure web/dist exists for go:embed
    mkdir -p web/dist
    cp -r ${webui}/share/dist/* web/dist
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gonzo \
      --bash <($out/bin/gonzo completion bash) \
      --fish <($out/bin/gonzo completion fish) \
      --zsh <($out/bin/gonzo completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "TUI log analysis tool";
    homepage = "https://gonzo.controltheory.com/";
    downloadPage = "https://github.com/control-theory/gonzo";
    changelog = "https://github.com/control-theory/gonzo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "gonzo";
  };
})
