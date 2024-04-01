{ lib, buildNpmPackage, fetchFromGitHub, mystmd, testers, nix-update-script }:

buildNpmPackage rec {
  pname = "mystmd";
  version = "1.1.48";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mystmd";
    rev = "mystmd@${version}";
    hash = "sha256-Uw/00EzgnrQYunABx7O35V+YwFnDDW+EI5NqMEUV8zk=";
  };

  npmDepsHash = "sha256-JSVdHhzOgzIwB61ST6vYVENtohjU6Q3lrp+hVPye02g=";

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
    maintainers = [ maintainers.marsam ];
    mainProgram = "myst";
  };
}
