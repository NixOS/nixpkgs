{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  markdown,
  pyyaml,
  pygments,

  # for passthru.tests
  mkdocstrings,
  mkdocs-material,
  mkdocs-mermaid2-plugin,
  hydrus,
}:

let
  extensions = [
    "arithmatex"
    "b64"
    "betterem"
    "caret"
    "critic"
    "details"
    "emoji"
    "escapeall"
    "extra"
    "highlight"
    "inlinehilite"
    "keys"
    "magiclink"
    "mark"
    "pathconverter"
    "progressbar"
    "saneheaders"
    "smartsymbols"
    "snippets"
    "striphtml"
    "superfences"
    "tabbed"
    "tasklist"
    "tilde"
  ];
in
buildPythonPackage rec {
  pname = "pymdown-extensions";
  version = "10.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = "pymdown-extensions";
    rev = "refs/tags/${version}";
    hash = "sha256-1AuN2kp7L6w8RvKky3IoX4ht9uQL6o2nm6dTDo/INC0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    markdown
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  disabledTests = [
    # test artifact mismatch
    "test_toc_tokens"
    # Tests fails with AssertionError
    "test_windows_root_conversion"
  ];

  pythonImportsCheck = map (ext: "pymdownx.${ext}") extensions;

  passthru.tests = {
    inherit
      mkdocstrings
      mkdocs-material
      mkdocs-mermaid2-plugin
      hydrus
      ;
  };

  meta = with lib; {
    description = "Extensions for Python Markdown";
    homepage = "https://facelessuser.github.io/pymdown-extensions/";
    license = with licenses; [
      mit
      bsd2
    ];
    maintainers = with maintainers; [ cpcloud ];
  };
}
