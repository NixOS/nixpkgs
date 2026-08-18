{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "imgp";
  version = "3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "imgp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CmpF4vIu7tXSnMTl/cBq/L4SHinT/ytO2OUjdjrFQRU=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.pillow ];

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  postInstall = ''
    installManPage imgp.1
    installShellCompletion --cmd imgp \
      --bash auto-completion/bash/imgp-completion.bash \
      --fish auto-completion/fish/imgp.fish \
      --zsh auto-completion/zsh/_imgp
  '';

  meta = {
    description = "High-performance CLI batch image resizer & rotator";
    mainProgram = "imgp";
    homepage = "https://github.com/jarun/imgp";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
  };
})
