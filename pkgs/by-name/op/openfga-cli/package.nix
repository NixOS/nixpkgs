{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "openfga-cli";
  version = "0.7.11";

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kExvR5FxC1VbT8xmkFREdeqJ+ism7Is1pTgrBMJp7Qs=";
  };

  vendorHash = "sha256-QBUPJ+rWT8BeIVx/437j/pUNBHmIVWkEyRpnWhYdjO4=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags =
    let
      buildInfoPkg = "github.com/openfga/cli/internal/build";
    in
    [
      "-s"
      "-w"
      "-X ${buildInfoPkg}.Version=${finalAttrs.version}"
      "-X ${buildInfoPkg}.Commit=${finalAttrs.version}"
      "-X ${buildInfoPkg}.Date=19700101"
    ];

  postInstall = ''
    completions_dir=$TMPDIR/fga_completions
    mkdir $completions_dir
    $out/bin/fga completion bash > $completions_dir/fga.bash
    $out/bin/fga completion zsh > $completions_dir/_fga.zsh
    $out/bin/fga completion fish > $completions_dir/fga.fish
    installShellCompletion $completions_dir/*
  '';

  meta = {
    description = "Cross-platform CLI to interact with an OpenFGA server";
    homepage = "https://github.com/openfga/cli";
    license = lib.licenses.asl20;
    mainProgram = "fga";
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
