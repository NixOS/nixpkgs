{ lib, buildNpmPackage, fetchFromGitHub, mystmd, testers, nix-update-script }:

buildNpmPackage rec {
  pname = "mystmd";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mystmd";
    rev = "mystmd@${version}";
    hash = "sha256-aZUDIQs4n2s842tq23pU/ZUW+1fF4XXEmgnapdZH8wQ=";
  };

  npmDepsHash = "sha256-IXdmzuQaBEbwjXssYaDLvxyTl+i2U/JTalg8lSGvuR0=";

  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    install -D packages/mystmd/dist/myst.cjs $out/bin/myst

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = mystmd;
      version = "v${version}";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Command line tools for working with MyST Markdown";
    homepage = "https://github.com/executablebooks/mystmd";
    changelog = "https://github.com/executablebooks/mystmd/blob/${src.rev}/packages/myst-cli/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "myst";
  };
}
