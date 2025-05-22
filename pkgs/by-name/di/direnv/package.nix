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
  version = "2.36.0";

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
    rev = "v${version}";
    hash = "sha256-xqHc4Eb0mHQezmElJv20AMNQPgusXdvskNmlO+JP1lw=";
  };

  vendorHash = "sha256-+7HnbJ6cIzYHkEJVcp2IydHyuqD5PfdL6TUcq7Dpluk=";

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
