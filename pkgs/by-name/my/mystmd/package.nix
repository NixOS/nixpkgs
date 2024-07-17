{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  mystmd,
  testers,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "mystmd";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mystmd";
    rev = "mystmd@${version}";
    hash = "sha256-SxUZvPSitzWZzTa490dkJWw6fZ5PtN8hy7fglifPn6o=";
  };

  npmDepsHash = "sha256-fwjtEw2mAnNX7lo9ovCC58qqtJPDLc2Ho9I1Ui0k/iI=";

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
