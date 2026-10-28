{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dfmt";
  version = "1.2.0";
  pyproject = true;

  build-system = [
    python3Packages.poetry-core
  ];

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-evY2DKjVVvHP6CuX8DuNHqWp1t4fowGCkMhEtlZtnW4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api' \
      --replace-fail 'poetry>=' 'poetry-core>=' \
  '';

  meta = {
    description = "Format paragraphs, comments and doc strings";
    mainProgram = "dfmt";
    homepage = "https://github.com/dmerejkowsky/dfmt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ cole-h ];
  };
})
