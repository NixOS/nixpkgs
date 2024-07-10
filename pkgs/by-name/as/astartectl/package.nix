{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:
buildGoModule rec {
  pname = "astartectl";
  version = "23.5.1";

  # Workaround for go vendor failing
  # https://github.com/astarte-platform/astartectl/pull/244
  postPatch = "go mod edit -go=1.22";

  src = fetchFromGitHub {
    owner = "astarte-platform";
    repo = "astartectl";
    rev = "v${version}";
    hash = "sha256-ntlLk7soiZq6Ql6k/RG9PdHawguRV6Wha8C+5FM+2og=";
  };

  vendorHash = "sha256-3k/G7fLll19XG2RU8YsepWv8BtkCmiLg4/c7lSvx+9k=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd astartectl \
      --bash <($out/bin/astartectl completion bash) \
      --fish <($out/bin/astartectl completion fish) \
      --zsh <($out/bin/astartectl completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/astarte-platform/astartectl";
    description = "Astarte command line client utility";
    license = licenses.asl20;
    mainProgram = "astartectl";
    maintainers = with maintainers; [ noaccos ];
  };
}
