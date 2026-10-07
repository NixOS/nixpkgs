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

buildGoModule (finalAttrs: {
  pname = "direnv";
  version = "2.38.1";

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zznrjJb18TyhGMVx4bORX6wuE8+OH66qplJBwHj5drw=";
  };

  vendorHash = "sha256-3ojb8iLIzhjUZa7Gt+gJjOFy9qm4LOrFBLZ6fk5x1HM=";

  # we have no bash at the moment for windows
  env.BASH_PATH = lib.optionalString (!stdenv.hostPlatform.isWindows) "${bash}/bin/bash";

  # Build a static executable to avoid environment runtime impurities
  env.CGO_ENABLED = 0;

  # With CGO disabled the internal linker is used by default; remove the
  # explicit -linkmode=external flag from the Makefile which is incompatible
  # with CGO_ENABLED=0 (see https://github.com/NixOS/nixpkgs/pull/486452)
  postPatch = ''
    substituteInPlace GNUmakefile --replace-fail " -linkmode=external" ""
  '';

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

  postInstall = ''
    rm -rf "$out/share/fish"
  '';

  meta = {
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
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zimbatm ];
    mainProgram = "direnv";
  };
})
