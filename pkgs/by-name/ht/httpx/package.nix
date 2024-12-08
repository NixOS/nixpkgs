{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "httpx";
  version = "1.6.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "httpx";
    rev = "refs/tags/v${version}";
    hash = "sha256-fkHMtFshRNtRhsxjbYOkeL2cln84NAa01jcGKips5Kk=";
  };

  vendorHash = "sha256-zTPJtuKPtsVsgMwHFjVwAh1/3DudW7TPWOMJ20nNu1I=";

  subPackages = [ "cmd/httpx" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

  versionCheckProgramArg = [ "-version" ];

  meta = with lib; {
    description = "Fast and multi-purpose HTTP toolkit";
    longDescription = ''
      httpx is a fast and multi-purpose HTTP toolkit allow to run multiple
      probers using retryablehttp library, it is designed to maintain the
      result reliability with increased threads.
    '';
    homepage = "https://github.com/projectdiscovery/httpx";
    changelog = "https://github.com/projectdiscovery/httpx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "httpx";
  };
}
