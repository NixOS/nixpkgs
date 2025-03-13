{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "glow";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    hash = "sha256-pYXzm6HEqxJRPDdiUb+yij3iA2FhFYZOdRvQ69grcuU=";
  };

  vendorHash = "sha256-lnD3SdPqZO+xfsR5YhvIAr9Gy1sA1LXi4SP/d/Rv/6g=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd glow \
      --bash <($out/bin/glow completion bash) \
      --fish <($out/bin/glow completion fish) \
      --zsh <($out/bin/glow completion zsh)
  '';

  meta = with lib; {
    description = "Render markdown on the CLI, with pizzazz!";
    homepage = "https://github.com/charmbracelet/glow";
    changelog = "https://github.com/charmbracelet/glow/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      Br1ght0ne
      penguwin
    ];
    mainProgram = "glow";
  };
}
