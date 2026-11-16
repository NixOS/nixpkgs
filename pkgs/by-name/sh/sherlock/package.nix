{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "sherlock";
  version = "0.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sherlock-project";
    repo = "sherlock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pc8/04+W77rvMnK0zYaYkHvmZ5N8gYFM6ZNRHN4o1MM=";
  };

  patches = [
    # Avoid hardcoding sherlock
    ./fix-sherlock-bin-test.patch
  ];

  postPatch = ''
    substituteInPlace tests/sherlock_interactives.py \
      --replace-fail @sherlockBin@ "$out/bin/sherlock"
    substituteInPlace sherlock_project/__init__.py \
      --replace-fail "__version__     = get_version()" "__version__ = \"${finalAttrs.version}\""
  '';

  nativeBuildInputs = [ makeWrapper ];

  dependencies = with python3.pkgs; [
    certifi
    colorama
    openpyxl
    pandas
    pysocks
    requests
    requests-futures
    stem
    torrequest
    tomli
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  pythonRelaxDeps = [
    "pandas"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -R ./sherlock_project $out/share

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${python3.interpreter} $out/bin/sherlock \
      --add-flags "-m" \
      --add-flags "sherlock_project" \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/share"
  '';

  nativeCheckInputs = with python3.pkgs; [
    rstr
    pytestCheckHook
    jsonschema
  ];

  disabledTestMarks = [
    # tests require internet access
    "online"
  ];

  meta = {
    homepage = "https://sherlockproject.xyz/";
    description = "Hunt down social media accounts by username across social networks";
    license = lib.licenses.mit;
    mainProgram = "sherlock";
    maintainers = with lib.maintainers; [ applePrincess ];
  };
})
