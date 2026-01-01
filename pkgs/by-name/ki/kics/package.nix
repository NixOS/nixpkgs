{
  lib,
  buildGoModule,
  fetchFromGitHub,
  kics,
  testers,
}:

buildGoModule rec {
  pname = "kics";
<<<<<<< HEAD
  version = "2.1.17";
=======
  version = "2.1.16";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "kics";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-GVzzQaf/UO+RyunTILoee7mgPOSbb2n28GY7FUB/BC0=";
  };

  vendorHash = "sha256-yXnVY3LtyaY8SMRXs+FJOTXa8SxBPJ92Znq/wLWZqzo=";
=======
    hash = "sha256-J+qTLS4NQK3XkXTOQ88kJm+evrpTmORi6aZMIMF2mxc=";
  };

  vendorHash = "sha256-onj9XCnvYP75NWkLLLQ4OePlMNDVDD1xxUq3SZIx8Po=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
