{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pgsrip";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "pgsrip";
    tag = finalAttrs.version;
    hash = "sha256-jFFPrjWacUSCgjheLblvwKhbTFOB4sHvN5tyAhSJxhY=";
  };

  # Before click 8.5.0 [1^], `ParamType` didn't have a `__class_getitem__` [2^],
  # so `click.ParamType[Language, str]` would not be considered as a type hint
  # and click fails at runtime with: `TypeError: type 'ParamType' is not subscriptable`.
  #
  # At the time of writing, click in Nixpkgs is at version 8.3.3, although
  # there is an open PR to update it [3^].
  #
  # The easiest fix for now is to just disable these type hints until click is
  # updated.
  #
  # [1^]: https://github.com/pallets/click/pull/3407
  # [2^]: https://docs.python.org/3/reference/datamodel.html#the-purpose-of-class-getitem
  # [3^]: https://github.com/NixOS/nixpkgs/pull/544890
  postPatch = lib.optionalString (lib.versionOlder python3Packages.click.version "8.5.0") ''
    substituteInPlace pgsrip/cli.py \
      --replace-fail \
        "click.ParamType[Language, str]" \
        "click.ParamType" \
      --replace-fail \
        "click.ParamType[timedelta, str]" \
        "click.ParamType" \
      --replace-fail \
        "click.ParamType[frozenset[int], str]" \
        "click.ParamType"
  '';

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    babelfish
    cleanit
    click
    numpy
    opencv-python
    pysrt
    pytesseract
    setuptools
    trakit
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    # fails to find the `git` dir, which is removed by the fetcher
    "test_repository_knowledge_is_consistent"
  ];

  pythonImportsCheck = [ "pgsrip" ];

  meta = {
    description = "Rip your PGS subtitles";
    homepage = "https://github.com/ratoaq2/pgsrip";
    changelog = "https://github.com/ratoaq2/pgsrip/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "pgsrip";
  };
})
