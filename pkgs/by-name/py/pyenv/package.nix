{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pyenv";
  version = "2.6.22";

  src = fetchFromGitHub {
    owner = "pyenv";
    repo = "pyenv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F4SZeF9YriAog88hRH/3GWajPtpBTBjEiVgqpxoFS/I=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  configureScript = "src/configure";

  makeFlags = [
    "-C"
    "src"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -R bin "$out/bin"
    cp -R libexec "$out/libexec"
    cp -R plugins "$out/plugins"

    runHook postInstall
  '';

  postInstall = ''
    installManPage man/man1/pyenv.1
    installShellCompletion completions/pyenv.{bash,fish,zsh}
  '';

  meta = {
    description = "Simple Python version management";
    homepage = "https://github.com/pyenv/pyenv";
    changelog = "https://github.com/pyenv/pyenv/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "pyenv";
  };
})
