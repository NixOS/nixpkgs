{
  lib,
  buildGoModule,
  fetchFromGitHub,
  kics,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "kics";
  version = "2.1.20";

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "kics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bgDOP6vFGz0D5ZJbAPB6oiq9ZeuiOKzMdNXm5KLpqdE=";
  };

  vendorHash = "sha256-XS2x0qbZKJD9V+X+9bryxO85UMHwVpDehbh/arHUQSU=";

  subPackages = [ "cmd/console" ];

  postInstall = ''
    mv $out/bin/console $out/bin/kics
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Checkmarx/kics/v2/internal/constants.SCMCommit=${finalAttrs.version}"
    "-X=github.com/Checkmarx/kics/v2/internal/constants.Version=${finalAttrs.version}"
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
    changelog = "https://github.com/Checkmarx/kics/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ patryk4815 ];
    mainProgram = "kics";
  };
})
