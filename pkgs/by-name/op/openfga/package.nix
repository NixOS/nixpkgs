{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  pname = "openfga";
  version = "1.10.3";
in

buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "openfga";
    rev = "v${version}";
    hash = "sha256-iP4VzQDScLAiRArVKh9n0AcPXZHPs+xRi4K9S0Z7n48=";
  };

  vendorHash = "sha256-421jf8XSCBteKQ7cr7ln/oBJgWxFsIqY+ccwW2R4/ro=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags =
    let
      buildInfoPkg = "github.com/openfga/openfga/internal/build";
    in
    [
      "-s"
      "-w"
      "-X ${buildInfoPkg}.Version=${version}"
      "-X ${buildInfoPkg}.Commit=${version}"
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
}
