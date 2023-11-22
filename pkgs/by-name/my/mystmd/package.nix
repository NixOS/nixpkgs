{ lib, buildNpmPackage, fetchFromGitHub, mystmd, testers }:

buildNpmPackage rec {
  pname = "mystmd";
  version = "1.1.29";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mystmd";
    rev = "mystmd@${version}";
    hash = "sha256-vI30dAcHdVtfD3xWIEytlDaobRX7Wkc7xt8vVHdXJxY=";
  };

  npmDepsHash = "sha256-l/jpNCVZe++o494W4EV86VAVdH9W8W8I0+dC2rBome8=";

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
