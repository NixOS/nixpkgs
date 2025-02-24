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
  version = "1.3.18";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mystmd";
    rev = "mystmd@${version}";
    hash = "sha256-20Cxs4ib7xRn4UC9ShiQ+KnyrTCmW/vII7QN9BObY78=";
  };

  npmDepsHash = "sha256-dcjOxEYTG/EnBRu+RE7cpSEvNmG32QsDDYzItaNTpa0=";

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
