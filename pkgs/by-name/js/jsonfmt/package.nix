{
  lib,
  buildGoModule,
  fetchFromGitHub,
<<<<<<< HEAD
  versionCheckHook,
=======
  testers,
  jsonfmt,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildGoModule rec {
  pname = "jsonfmt";
<<<<<<< HEAD
  version = "0.5.2";
=======
  version = "0.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "jsonfmt";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-CMBqqTGpqoErFPKn4lxMB9XrdlhZcY6qbRZZVUVMQj0=";
  };

  vendorHash = "sha256-QcljmDsz5LsXfHaXNVBU7IIVVgkm3Vfnirchx5ZOMSg=";

  nativeInstallCheckInputs = [ versionCheckHook ];
=======
    rev = "v${version}";
    hash = "sha256-4SNpW/+4S4sEwjM7b9ClqKqwqFFVbCVv5VnftGIHtjo=";
  };

  vendorHash = "sha256-6pCgBCwHgTRnLDNfveBEKbs7kiXSSacD0B82A2Sbl1U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

<<<<<<< HEAD
  doInstallCheck = true;

  meta = {
    description = "Formatter for JSON files";
    homepage = "https://github.com/caarlos0/jsonfmt";
    changelog = "https://github.com/caarlos0/jsonfmt/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
=======
  passthru.tests = {
    version = testers.testVersion {
      package = jsonfmt;
    };
  };

  meta = with lib; {
    description = "Formatter for JSON files";
    homepage = "https://github.com/caarlos0/jsonfmt";
    changelog = "https://github.com/caarlos0/jsonfmt/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "jsonfmt";
  };
}
