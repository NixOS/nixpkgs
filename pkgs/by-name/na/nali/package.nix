{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "nali";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "zu1k";
    repo = "nali";
    rev = "v${version}";
    hash = "sha256-5AI8TAKYFqjgLVKob9imrf7yVmXmAPq/zHh1bDfC5r0=";
  };

  vendorHash = "sha256-wIp/ShUddz+RIcsEuKWUfxsV/wNB2X1jZtIltBZ0ROM=";
  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X github.com/zu1k/nali/internal/constant.Version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME="$TMPDIR"
    # write to temp files to avoid race condition in config loading
    $out/bin/nali completion bash > nali.bash
    $out/bin/nali completion fish > nali.fish
    $out/bin/nali completion zsh  > nali.zsh
    installShellCompletion --cmd nali nali.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Offline tool for querying IP geographic information and CDN provider";
    homepage = "https://github.com/zu1k/nali";
    license = licenses.mit;
    maintainers = with maintainers; [
      diffumist
      xyenon
    ];
    mainProgram = "nali";
  };
}
