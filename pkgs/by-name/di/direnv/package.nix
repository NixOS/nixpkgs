{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  bash,
  fish,
  zsh,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "direnv";
  version = "2.37.1";

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
    rev = "v${version}";
    hash = "sha256-92xjoCjH5O7wx8U7OFG8Lw9eDOAdeVKNvxBHW+TiniM=";
  };

  vendorHash = "sha256-SAIGFQGACTB3Q0KnIdiKKNYY6fVjf/09wGqNr0Hkg+M=";

  # we have no bash at the moment for windows
  BASH_PATH = lib.optionalString (!stdenv.hostPlatform.isWindows) "${bash}/bin/bash";

  # replace the build phase to use the GNUMakefile instead
  buildPhase = ''
    make BASH_PATH=$BASH_PATH
  '';

  installPhase = ''
    make install PREFIX=$out
  '';

  nativeCheckInputs = [
    fish
    zsh
    writableTmpDirAsHomeHook
  ];

  checkPhase = ''
    runHook preCheck

    make test-go test-bash test-fish test-zsh

    runHook postCheck
  '';

  meta = with lib; {
    description = "Shell extension that manages your environment";
    longDescription = ''
      Once hooked into your shell direnv is looking for an .envrc file in your
      current directory before every prompt.

      If found it will load the exported environment variables from that bash
      script into your current environment, and unload them if the .envrc is
      not reachable from the current path anymore.

      In short, this little tool allows you to have project-specific
      environment variables.
    '';
    homepage = "https://direnv.net";
    license = licenses.mit;
    maintainers = [ maintainers.zimbatm ];
    mainProgram = "direnv";
  };
}
