{ lib
, fetchFromGitHub
, python3Packages
, xvfb-run
, firefox-esr
, geckodriver
, makeWrapper
}:

python3Packages.buildPythonApplication rec {
  pname = "eye-witness";
  version = "20230525.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "redsiege";
    repo = "EyeWitness";
    rev = "v${version}";
    hash = "sha256-nSPpPbwqagc5EadQ4AHgLhjQ0kDjmbdcwE/PL5FDL4I=";
  };

  build-system = with python3Packages; [
    setuptools
  ] ++ [
    makeWrapper
  ];

  dependencies = with python3Packages; [
    selenium
    fuzzywuzzy
    pyvirtualdisplay
    pylev
    netaddr
    pydevtool
  ] ++ [
    firefox-esr
    xvfb-run
    geckodriver
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/eyewitness}
    cp -R * $out/share/eyewitness

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    makeWrapper "${python3Packages.python.interpreter}" "$out/bin/eyewitness" \
      --set PYTHONPATH "$PYTHONPATH" \
      --add-flags "$out/share/eyewitness/Python/EyeWitness.py"

    runHook postFixup
  '';

  meta = with lib; {
    description = "Take screenshots of websites, and identify admin interfaces";
    homepage = "https://github.com/redsiege/EyeWitness";
    changelog = "https://github.com/redsiege/EyeWitness/blob/${src.rev}/CHANGELOG";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "eye-witness";
    platforms = platforms.all;
  };
}
