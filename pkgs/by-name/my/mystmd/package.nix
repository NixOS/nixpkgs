{ lib, buildNpmPackage, fetchFromGitHub, mystmd, testers }:

buildNpmPackage rec {
  pname = "mystmd";
  version = "1.1.23";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mystmd";
    rev = "mystmd@${version}";
    hash = "sha256-+zgAm3v7XcNhhVOFueRqJijteQqMCZmE33hDyR4d5bA=";
  };

  npmDepsHash = "sha256-8brgDSV0BBggYUnizV+24RQMXxPd6HUBDYrw9fJtL+M=";

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
