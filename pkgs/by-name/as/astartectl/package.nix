{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:
buildGoModule rec {
  pname = "astartectl";
  version = "24.5.0";

  src = fetchFromGitHub {
    owner = "astarte-platform";
    repo = "astartectl";
    rev = "v${version}";
    hash = "sha256-4Iyd+1hLSatWyeV2J7RSqo2jVEc8dSp5JBObsn3RciI=";
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
