{
  lib,
  installShellFiles,
  rustPlatform,
  fetchFromGitLab,
  stdenv,
  mdbook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "engage";
  version = "0.2.1";

  outputs = [
    "out"
    "doc"
  ];

  env = {
    ENGAGE_DOCS_LINK = "file://${builtins.placeholder "doc"}/share/doc/${finalAttrs.pname}/index.html";
  };

  src = fetchFromGitLab {
    domain = "gitlab.computer.surgery";
    owner = "charles";
    repo = "engage";
    rev = "v${finalAttrs.version}";
    hash = "sha256-n7ypFJBYT712Uzh1NnWWSOIpEDKR0e6sQxbiIN6pZgo=";
  };

  cargoHash = "sha256-UTIxxPBtxzsZilxriAT8ksl2ovoDzIhB+8f+b2cGN3k=";

  nativeBuildInputs = [
    installShellFiles
  ];

  checkFlags = [
    # Upstream doesn't set `ENGAGE_DOCS_LINK` during tests so the output differs.
    "--skip=long_help"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd engage ${
      builtins.concatStringsSep " " (
        builtins.map (shell: "--${shell} <($out/bin/engage completions ${shell})") [
          "bash"
          "zsh"
          "fish"
        ]
      )
    }

    ${lib.getExe mdbook} build
    mkdir -p "$doc/share/doc"
    mv public "$doc/share/doc/${finalAttrs.pname}"
  '';

  meta = {
    description = "Task runner with DAG-based parallelism";
    mainProgram = "engage";
    homepage = "https://gitlab.computer.surgery/charles/engage";
    changelog = "https://charles.gitlab-pages.computer.surgery/engage/changelog.html";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ CobaltCause ];
  };
})
