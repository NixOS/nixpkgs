{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  bash,
  fish,
  zsh,
}:

buildGoModule rec {
  pname = "direnv";
  version = "2.35.0";

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
    rev = "v${version}";
    hash = "sha256-C4FkBS+2MZGGlpWb7ng4Aa9IvqEuY716M5h2W3b8N1E=";
  };

  vendorHash = "sha256-O2NZgWn00uKLstYPIj9LwyF4kmitJ1FXltazv8RrmZg=";

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
  ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    make test-go test-bash test-fish test-zsh
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
