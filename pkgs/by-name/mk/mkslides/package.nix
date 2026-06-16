{
  lib,
  python3Packages,
  fetchPypi,
  fetchpatch2,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mkslides";
  version = "2.0.18";

  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-pxCnoU03xuOZoLctSX4HbxprTGvBLCtawojnqgdVT6M=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/MartenBE/mkslides/commit/2ffc01714ef55c979afe2528acdcedb49e773f2f.patch?full_index=1";
      hash = "sha256-a4SsOF9oevcoUhajC//hieAh7JkhW2rfwHjoCuRwBho=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.23,<0.9.0" "uv_build"
  '';

  build-system = with python3Packages; [ uv-build ];

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

  meta = {
    description = "Build static HTML slideshow files from Markdown files.";
    homepage = "https://github.com/MartenBE/mkslides";
    changelog = "https://github.com/MartenBE/mkslides/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "mkslides";
  };

  __structuredAttrs = true;
})
