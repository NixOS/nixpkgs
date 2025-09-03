{
  lib,
  buildGoModule,
  fetchFromGitHub,
  kics,
  testers,
}:

buildGoModule rec {
  pname = "kics";
  version = "2.1.12";

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "kics";
    tag = "v${version}";
    hash = "sha256-InoH/BzRJtJaFGL1OjLpRoz72Gkrf03WRZQUDyxnFDM=";
  };

  vendorHash = "sha256-kKK3kSWjork6KZdPzKySsiHR0bOLKlzltP/u6ZQioqM=";

  subPackages = [ "cmd/console" ];

  postInstall = ''
    mv $out/bin/console $out/bin/kics
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Checkmarx/kics/v2/internal/constants.SCMCommit=${version}"
    "-X=github.com/Checkmarx/kics/v2/internal/constants.Version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = kics;
    command = "kics version";
  };

  meta = {
    description = "Tool to check for vulnerabilities and other issues";
    longDescription = ''
      Find security vulnerabilities, compliance issues, and
      infrastructure misconfigurations early in the development
      cycle of your infrastructure-as-code.
    '';
    homepage = "https://github.com/Checkmarx/kics";
    changelog = "https://github.com/Checkmarx/kics/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ patryk4815 ];
    mainProgram = "kics";
  };
}
