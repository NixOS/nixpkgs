{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  pname = "openfga";
  version = "1.5.3";
in

buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "openfga";
    rev = "v${version}";
    hash = "sha256-+ECfBG0Z1XnopMPbq9jngcZ3lcSFOIomWo5iD0T1teQ=";
  };

  vendorHash = "sha256-MyoqdmNtpsoT08BKA9DPlpldIEXb82qzeXnW4KQXTiE=";

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
    description = "A high performance and flexible authorization/permission engine built for developers and inspired by Google Zanzibar";
    homepage = "https://openfga.dev/";
    license = lib.licenses.asl20;
    mainProgram = "openfga";
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
}
