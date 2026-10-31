{
  lib,
  asciidoctor,
  fetchPypi,
  installShellFiles,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "copr-cli";
  version = "2.6";
  pyproject = true;

  src = fetchPypi {
    pname = "copr_cli";
    inherit (finalAttrs) version;
    hash = "sha256-smNR1kg8IcN0p2iVFZlNMpHy1GqhEQJEAv04qdvhBLM=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies =
    with python3Packages;
    [
      argcomplete
      copr
      humanize
      jinja2
      rich
      setuptools
    ]
    ++ copr.optional-dependencies.gssapi;

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
    python3Packages.argcomplete
  ];

  postBuild = ''
    asciidoctor -b manpage -o copr-cli.1 man/copr-cli.1.asciidoc
  '';

  postInstall = ''
    installManPage copr-cli.1 man/copr.1
    installShellCompletion --cmd copr-cli \
      --bash <(register-python-argcomplete copr-cli --shell bash) \
      --zsh <(register-python-argcomplete copr-cli --shell zsh) \
      --fish <(register-python-argcomplete copr-cli --shell fish)
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "copr_cli" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Command line interface for the Copr build service";
    homepage = "https://github.com/fedora-copr/copr";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "copr-cli";
  };
})
