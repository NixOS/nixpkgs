{ lib, buildNpmPackage, fetchFromGitHub, mystmd, testers }:

buildNpmPackage rec {
  pname = "mystmd";
  version = "1.1.27";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mystmd";
    rev = "mystmd@${version}";
    hash = "sha256-aMoL125DjXM/HL+ebCkjywwEv1VTKPmF2CV/TJd1LMU=";
  };

  npmDepsHash = "sha256-i1tbHCI/z/kiGIROlVMvnt7x4f8D7pzTk1BcSPFDwFw=";

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
