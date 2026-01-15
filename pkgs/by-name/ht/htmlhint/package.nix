{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "htmlhint";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "htmlhint";
    repo = "HTMLHint";
    rev = "v${version}";
    hash = "sha256-zRn6fqziqgp3cOPZfkmN+KP84bgjdPmaHD7n6rtiHVA=";
  };

  npmDepsHash = "sha256-L/yVM/HoBewzoADn9M+c2Er5LFEiZXajYIK8fvsDdio=";

  meta = {
    changelog = "https://github.com/htmlhint/HTMLHint/blob/${src.rev}/CHANGELOG.md";
    description = "Static code analysis tool for HTML";
    homepage = "https://github.com/htmlhint/HTMLHint";
    license = lib.licenses.mit;
    mainProgram = "htmlhint";
    maintainers = [ ];
  };
}
