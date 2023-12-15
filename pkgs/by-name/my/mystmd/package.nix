{ lib, buildNpmPackage, fetchFromGitHub, mystmd, testers, nix-update-script }:

buildNpmPackage rec {
  pname = "mystmd";
  version = "1.1.31";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mystmd";
    rev = "mystmd@${version}";
    hash = "sha256-1zjz1HJxa8ww02MnqravCWM51bpuSpnLxn34Kazbt5o=";
  };

  npmDepsHash = "sha256-7H3VKJAzbsKLhyFD7MoASsOyJwbt6vERO6LM2mpz/y0=";

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
