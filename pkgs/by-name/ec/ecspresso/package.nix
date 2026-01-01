{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "ecspresso";
<<<<<<< HEAD
  version = "2.7.0";
=======
  version = "2.6.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-GaxMpc6VUnPPlpFxptWFEpAec5VuSR0EOBOuZufrxvM=";
=======
    hash = "sha256-7Lli3PQZDmMBzgVbHy8ayweK+yn23IVqPTI6M+Un5i0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  subPackages = [
    "cmd/ecspresso"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-NFuWMfw31BfolRd8yxleVdwFi/XcnHcSTOlqkm/stko=";
=======
  vendorHash = "sha256-UkfkCEyHwxOEEVcxtsMdeRuJhQqW3vLHEDf8+O82zs4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X main.buildDate=none"
    "-X main.Version=${version}"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "version";

  meta = {
    description = "Deployment tool for ECS";
    mainProgram = "ecspresso";
    license = lib.licenses.mit;
    homepage = "https://github.com/kayac/ecspresso/";
    maintainers = with lib.maintainers; [
      FKouhai
    ];
  };
}
