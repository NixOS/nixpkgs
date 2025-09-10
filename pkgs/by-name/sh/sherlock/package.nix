{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sherlock";
  version = "0.15.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sherlock-project";
    repo = "sherlock";
    tag = "v${version}";
    hash = "sha256-+fQDvvwsLpiEvy+vC49AzlOA/KaKrhhpS97sZvFbpLA=";
  };

  patches = [
    # Avoid hardcoding sherlock
    ./fix-sherlock-bin-test.patch
  ];

  postPatch = ''
    substituteInPlace tests/sherlock_interactives.py \
      --replace @sherlockBin@ "$out/bin/sherlock"
  '';

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3.pkgs; [
    certifi
    colorama
    pandas
    pysocks
    requests
    requests-futures
    stem
    torrequest
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
    pytestCheckHook
    poetry-core
    jsonschema
    openpyxl
    stem
  ];

  pythonRelaxDeps = [ "stem" ];

  disabledTestMarks = [
    "online"
  ];

  meta = {
    homepage = "https://sherlockproject.xyz/";
    description = "Hunt down social media accounts by username across social networks";
    license = lib.licenses.mit;
    mainProgram = "sherlock";
    maintainers = with lib.maintainers; [ applePrincess ];
  };
}
