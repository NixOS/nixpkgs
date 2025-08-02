{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "pyenv";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "pyenv";
    repo = "pyenv";
    tag = "v${version}";
    hash = "sha256-X4Gwjbgl7y/p/CEz1Z2wydP7ZBHD1i8lzmuYISVL/bo=";
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
    changelog = "https://github.com/pyenv/pyenv/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tjni ];
    platforms = lib.platforms.all;
    mainProgram = "pyenv";
  };
}
