{
  lib,
  buildGoModule,
  fetchFromGitHub,
  kics,
  testers,
}:

buildGoModule rec {
  pname = "kics";
  version = "2.1.9";

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "kics";
    tag = "v${version}";
    hash = "sha256-VEymPj9zX7XidzLBa2ML4hJ4GRmsrpP39sJQp1rteQ4=";
  };

  vendorHash = "sha256-blzzr7lY0nsvhkNnMe+MesqOc7yUwo4I5BRf5kRwC1E=";

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

  meta = with lib; {
    description = "Tool to check for vulnerabilities and other issues";
    longDescription = ''
      Find security vulnerabilities, compliance issues, and
      infrastructure misconfigurations early in the development
      cycle of your infrastructure-as-code.
    '';
    homepage = "https://github.com/Checkmarx/kics";
    changelog = "https://github.com/Checkmarx/kics/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ patryk4815 ];
    mainProgram = "kics";
  };
}
