{
  lib,
  fetchFromGitLab,
  buildGoModule,
  installShellFiles,
}:
buildGoModule rec {
  pname = "optinix";
  version = "0.1.4";

  src = fetchFromGitLab {
    owner = "hmajid2301";
    repo = "optinix";
    rev = "v${version}";
    hash = "sha256-OuzLTygfJj1ILT0lAcBC28vU5YLuq0ErZHsLHoQNWBA=";
  };

  vendorHash = "sha256-gnxG4VqdZbGQyXc1dl3pU7yr3BbZPH17OLAB3dffcrk=";

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    substituteInPlace vendor/modernc.org/libc/honnef.co/go/netdb/netdb.go \
      --replace-fail '!os.IsNotExist(err)' '!os.IsNotExist(err) && !os.IsPermission(err)'
  '';

  postInstall = ''
    installShellCompletion --cmd optinix \
      --bash <($out/bin/optinix completion bash) \
      --fish <($out/bin/optinix completion fish) \
      --zsh <($out/bin/optinix completion zsh)
  '';

  meta = {
    description = "Tool for searching options in Nix";
    homepage = "https://gitlab.com/hmajid2301/optinix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmajid2301 ];
    changelog = "https://gitlab.com/hmajid2301/optinix/-/releases/v${version}";
    mainProgram = "optinix";
  };
}
