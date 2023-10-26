{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "mystmd";
  version = "1.1.22";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mystmd";
    rev = "mystmd@${version}";
    hash = "sha256-jx/UCC/Cl5kqAbMzeikTmrx9xWS02OCp3rn0pvtIAPY=";
  };

  npmDepsHash = "sha256-1qQ19iB7N+KvO1uUdEMU1iN91FMQs4wzfTCdv6wfn30=";

  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    install -D packages/mystmd/dist/myst.cjs $out/bin/myst

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line tools for working with MyST Markdown";
    homepage = "https://github.com/executablebooks/mystmd";
    changelog = "https://github.com/executablebooks/mystmd/blob/${src.rev}/packages/myst-cli/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    mainProgram = "myst";
  };
}
