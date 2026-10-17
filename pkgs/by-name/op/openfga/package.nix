{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "openfga";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "openfga";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HI3iQIV21AHb2hpoNA++2Wm5yeENhASe9MoWwzrtL5A=";
  };

  vendorHash = "sha256-Jd8EtZf97e7qr7GcK1sMjC14mga1Jui8aNvbMAHZyA0=";

  __structuredAttrs = true;

  nativeBuildInputs = [ installShellFiles ];

  ldflags =
    let
      buildInfoPkg = "github.com/openfga/openfga/internal/build";
    in
    [
      "-s"
      "-w"
      "-X ${buildInfoPkg}.Version=${finalAttrs.version}"
      "-X ${buildInfoPkg}.Commit=${finalAttrs.version}"
      "-X ${buildInfoPkg}.Date=19700101"
    ];

  # Tests depend on docker
  doCheck = false;

  postInstall = ''
    completions_dir=$TMPDIR/openfga_completions
    mkdir $completions_dir
    $out/bin/openfga completion bash > $completions_dir/openfga.bash
    $out/bin/openfga completion zsh > $completions_dir/_openfga.zsh
    $out/bin/openfga completion fish > $completions_dir/openfga.fish
    installShellCompletion $completions_dir/*
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High performance and flexible authorization/permission engine built for developers and inspired by Google Zanzibar";
    changelog = "https://github.com/openfga/openfga/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://openfga.dev/";
    license = lib.licenses.asl20;
    mainProgram = "openfga";
    maintainers = with lib.maintainers; [
      jlesquembre
      anish
    ];
  };
})
