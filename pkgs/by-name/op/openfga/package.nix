{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "openfga";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "openfga";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fmTb5mRAbJGDfE4lLSFtfHuQv2pQn4fQnX7fTjq7KKs=";
  };

  vendorHash = "sha256-sd1kDRicWb5ShEFDCJIjv4kk2dA5XwABH3Ii/P3uVvI=";

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

  meta = {
    description = "High performance and flexible authorization/permission engine built for developers and inspired by Google Zanzibar";
    homepage = "https://openfga.dev/";
    license = lib.licenses.asl20;
    mainProgram = "openfga";
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
