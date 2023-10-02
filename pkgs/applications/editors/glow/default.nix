{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, stdenv
}:
buildGoModule rec {
  pname = "glow";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    sha256 = "sha256-CI0S9XJtJQClpQvI6iSb5rcHafEUwr2V6+Fq560lRfM=";
  };

  vendorHash = "sha256-2QrHBbhJ04r/vPK2m8J2KZSFrREDCc18tlKd7evghBc=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];
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
    maintainers = with maintainers; [ Br1ght0ne penguwin ];
    mainProgram = "glow";
  };
}
