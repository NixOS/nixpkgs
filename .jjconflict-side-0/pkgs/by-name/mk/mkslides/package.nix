{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mkslides";
  version = "2.0.23";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MartenBE";
    repo = "mkslides";
    tag = finalAttrs.version;
    hash = "sha256-pmlMZzOhTdgPf/D6NLLg3j/RZP4ldW3sOgafwZJtdtc=";
    fetchSubmodules = true; # reveal.js and highlight.js are submodules.
  };

  build-system = [ python3Packages.uv-build ];

  dependencies = with python3Packages; [
    beautifulsoup4
    click
    emoji
    jinja2
    jsonschema
    livereload
    markdown
    natsort
    omegaconf
    python-frontmatter
    pyyaml
    rich
    treelib
    types-beautifulsoup4
    types-markdown
  ];

  pythonImportsCheck = [ "mkslides" ];

  meta = {
    description = "Use mkslides to easily turn Markdown files into beautiful slides using the power of Reveal.js!";
    mainProgram = "mkslides";
    homepage = "https://github.com/MartenBE/mkslides";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.MartenBE
    ];
  };
})
