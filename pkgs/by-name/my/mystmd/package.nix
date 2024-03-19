{ lib, buildNpmPackage, fetchFromGitHub, mystmd, testers, nix-update-script }:

buildNpmPackage rec {
  pname = "mystmd";
  version = "1.1.47";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mystmd";
    rev = "mystmd@${version}";
    hash = "sha256-gF3IGkdMM4pbtHOVnhk35nxPBLqUSc/IzrXvg+duQa4=";
  };

  npmDepsHash = "sha256-63QS+vnIwkdMES2UrWvHeytWp5NuEf5uKpHA0m1XTHU=";

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
