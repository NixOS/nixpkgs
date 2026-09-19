{
  lib,
  fetchFromGitHub,
  gitMinimal,
  gnused,
  coreutils,
  nix-update,
  python3Packages,
  versionCheckHook,
  writeShellScript,
}:
python3Packages.buildPythonApplication rec {
  pname = "copr-cli";
  version = "2.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fedora-copr";
    repo = "copr";
    tag = "copr-cli-${version}-1";
    hash = "sha256-/eFno+EXhZ86g8++um620I1/Zn1niS5yYzn+ZxcR/eg=";
  };

  sourceRoot = "${src.name}/cli";

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    argcomplete
    beautifulsoup4
    copr
    humanize
    jinja2
    koji
    requests
    rich
  ];

  pythonImportsCheck = [ "copr_cli" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = writeShellScript "update-copr-cli" ''
    latest_tag="$(
      ${lib.getExe gitMinimal} ls-remote --tags --refs https://github.com/fedora-copr/copr.git 'copr-cli-*' \
        | ${lib.getExe gnused} -E 's|.*refs/tags/copr-cli-([0-9.]+)-[0-9]+$|\1|' \
        | ${lib.getExe' coreutils "sort"} -V \
        | ${lib.getExe' coreutils "tail"} -n 1
    )"
    test -n "$latest_tag"
    ${lib.getExe nix-update} "$UPDATE_NIX_ATTR_PATH" --version "$latest_tag"
  '';

  meta = {
    description = "Command-line interface for the Fedora Copr build system";
    homepage = "https://github.com/fedora-copr/copr";
    changelog = "https://github.com/fedora-copr/copr/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "copr-cli";
  };
}
