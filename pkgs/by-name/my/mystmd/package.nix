{ lib, buildNpmPackage, fetchFromGitHub, mystmd, testers }:

buildNpmPackage rec {
  pname = "mystmd";
  version = "1.1.26";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mystmd";
    rev = "mystmd@${version}";
    hash = "sha256-hDXqUjJXQqEpaGCdfxGuAnUraB5/RjZB4MmomAG4aPM=";
  };

  npmDepsHash = "sha256-uq3HbmkeJl3A46/rfm29v+oXFnZOwp2SFArm6Wtv+wo=";

  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    install -D packages/mystmd/dist/myst.cjs $out/bin/myst

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = mystmd;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Command line tools for working with MyST Markdown";
    homepage = "https://github.com/executablebooks/mystmd";
    changelog = "https://github.com/executablebooks/mystmd/blob/${src.rev}/packages/myst-cli/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    mainProgram = "myst";
  };
}
