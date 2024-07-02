{ lib
, fetchFromGitHub
, makeWrapper
, python3
, unstableGitUpdater
, poetry
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sherlock";
  version = "0-unstable-2024-06-09";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sherlock-project";
    repo = "sherlock";
    rev = "d678908c00f16c7f6c44efc0357cef713fa96739";
    hash = "sha256-XAXDqbdHQta9OiupbPmmyp3TK1VLtDQ7CadsOei/6rs=";
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
    cp -R ./sherlock $out/share

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${python3.interpreter} $out/bin/sherlock \
      --add-flags "-m" \
      --add-flags "sherlock" \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/share"
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    poetry
    poetry-core
    jsonschema
    openpyxl
    stem
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "stem"
  ];

  pytestFlagsArray = [
    "-m"
    "'not online'"
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    homepage = "https://sherlock-project.github.io/";
    description = "Hunt down social media accounts by username across social networks";
    license = licenses.mit;
    mainProgram = "sherlock";
    maintainers = with maintainers; [ applePrincess ];
  };
}
