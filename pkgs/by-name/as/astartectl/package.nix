{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:
buildGoModule rec {
  pname = "astartectl";
  version = "23.5.2";

  # Workaround for go vendor failing
  # https://github.com/astarte-platform/astartectl/pull/244
  postPatch = "go mod edit -go=1.22";

  src = fetchFromGitHub {
    owner = "astarte-platform";
    repo = "astartectl";
    rev = "v${version}";
    hash = "sha256-EIyta/10K6WQ1vzQZryz+c3K2AwMOUUQCw5f4Wkp6Yk=";
  };

  vendorHash = "sha256-NWPLHbUHrk/oJXCOJF8kKhQiZR8aqZChxuz73Acu1cM=";

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
