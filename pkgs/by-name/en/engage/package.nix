{
  lib,
  installShellFiles,
  rustPlatform,
  fetchFromGitLab,
  mdbook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "engage";
  version = "0.3.0";

  env = {
    ENGAGE_BOOK_PATH = "${placeholder "out"}/share/doc/${finalAttrs.pname}";
  };

  src = fetchFromGitLab {
    domain = "gitlab.computer.surgery";
    owner = "charles";
    repo = "engage";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dKnpovsBcx3fyDK2eSVf4vzJaQ0uNGcKoYSE56kUDEg=";
  };

  cargoHash = "sha256-wHPjVP/hzMdmKVYDzjUGoaSKwcf7A9nYeM5HhvBQ+bc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildAndTestSubdir = "crates/engage";

  postInstall = ''
    installShellCompletion --cmd engage ${
      builtins.concatStringsSep " " (
        map (shell: "--${shell} <(cargo xtask completions ${shell})") [
          "bash"
          "zsh"
          "fish"
        ]
      )
    }

    ${lib.getExe mdbook} build
    mkdir -p $out/share/doc
    mv public $out/share/doc/${finalAttrs.pname}
  '';

  meta = {
    description = "Process composer with ordering and parallelism based on directed acyclic graphs";
    mainProgram = "engage";
    homepage = "https://engage.computer.surgery";
    changelog = "https://engage.computer.surgery/changelog.html";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ CobaltCause ];
  };
})
