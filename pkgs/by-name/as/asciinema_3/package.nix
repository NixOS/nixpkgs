{
  lib,
  fetchFromGitHub,
  installShellFiles,
  python3,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asciinema";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jWRq/LeDdCETiOMkWr9EIWztb14IYGCSo05QPw5HZZk=";
  };

  cargoHash = "sha256-bGhShwH4BxE3O4/B8KSK1o7IXNDBmGuVt4kx5s8W/go=";

  env.ASCIINEMA_GEN_DIR = "gendir";

  strictDeps = true;

  nativeCheckInputs = [ python3 ];
  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage gendir/man/*
    installShellCompletion --cmd asciinema \
      --bash gendir/completion/asciinema.bash \
      --fish gendir/completion/asciinema.fish \
      --zsh gendir/completion/_asciinema
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    homepage = "https://asciinema.org/";
    description = "Terminal session recorder and the best companion of asciinema.org";
    longDescription = ''
      asciinema is a suite of tools for recording, replaying, and sharing
      terminal sessions. It is free and open-source software (FOSS), created
      by Marcin Kulik.

      Its typical use cases include creating tutorials, demonstrating
      command-line tools, and sharing reproducible bug reports. It focuses on
      simplicity and interoperability, which makes it a popular choice among
      computer users working with the command-line, such as developers or
      system administrators.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "asciinema";
    maintainers = with lib.maintainers; [
      jiriks74
      llakala
    ];
  };
})
