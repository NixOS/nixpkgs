{
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pkgs, # Only for pkgs.graphviz
  lib,
  setuptools,
  markdown,
}:

buildPythonPackage (finalAttrs: {
  pname = "markdown-inline-graphviz-extension";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cesaremorel";
    repo = "markdown-inline-graphviz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FUBRFImX5NOxyYAK7z5Bo8VKVQllTbEewEGZXtVMBQE=";
  };

  patches = [
    # Fix the version discrepancy between the package and the source code
    # Should be removed at the next release
    (fetchpatch {
      url = "https://github.com/cesaremorel/markdown-inline-graphviz/commit/579f10af9fe7187c717c20615f65774f898c1a0d.patch";
      hash = "sha256-PJdwQ6+vq28m55vbgFzlhMmgvFqGPsYfIaCYunG7bMU=";
    })
  ];

  # Using substituteInPlace because there's only one replacement
  postPatch = ''
    substituteInPlace markdown_inline_graphviz.py \
      --replace-fail "args = [command, '-T'+filetype]" "args = [\"${pkgs.graphviz}/bin/\" + command, '-T'+filetype]"
  '';

  build-system = [ setuptools ];

  dependencies = [ markdown ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [ "markdown_inline_graphviz" ];

  meta = {
    description = "Render inline graphs with Markdown and Graphviz";
    homepage = "https://github.com/cesaremorel/markdown-inline-graphviz/";
    changelog = "https://github.com/cesaremorel/markdown-inline-graphviz/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
