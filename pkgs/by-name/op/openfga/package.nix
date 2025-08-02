{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  pname = "openfga";
  version = "1.9.2";
in

buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "openfga";
    rev = "v${version}";
    hash = "sha256-jddtLyAvvY+I/vpXA7e40efxUfL4AjcEGwUiq1jccDg=";
  };

  vendorHash = "sha256-pDMf792e4U9s/ugQ2jto4HbtFEh3nXHTK71Hb5XnHB4=";

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
