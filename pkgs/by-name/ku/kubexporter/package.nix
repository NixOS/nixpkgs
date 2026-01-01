{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "kubexporter";
<<<<<<< HEAD
  version = "0.8.3";
=======
  version = "0.7.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "bakito";
    repo = "kubexporter";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-GSM4sO28RpCSAJRhhntkqD3RrMyZ1zEaEVeWFTqArAE=";
  };

  vendorHash = "sha256-+2wzD7V6De8wd8W+ML+Lr7A8bzpxVExPDg6uuvTh/zE=";
=======
    hash = "sha256-cSYUR6EfRMLyPNaKDBbwWzpSy7/Gxe9UtnCz+cWHwrw=";
  };

  vendorHash = "sha256-gPjfjOOh2HZaAaZt2FIb/Zy3xYKUNxC9+30TudfnDFQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/bakito/kubexporter/version.Version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for exporting Kubernetes resources as YAML or JSON files";
    homepage = "https://github.com/bakito/kubexporter";
    changelog = "https://github.com/bakito/kubexporter/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bakito ];
    mainProgram = "kubexporter";
  };
}
