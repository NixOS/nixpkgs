{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "recuperabit";
  version = "1.1.6-unstable-2025-03-02";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Lazza";
    repo = "RecuperaBit";
    rev = "f762099345ba8a6c7388253ee8c0c6b2284d30b9";
    hash = "sha256-1johhRBvFA3PszoEAulwnhV1ApsedzIC0aJSgUrgUX4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share
    cp -r . $out/share/recuperabit
    chmod +x $out/share/recuperabit/main.py
    ln -s $out/share/recuperabit/main.py $out/bin/recuperabit

    runHook postInstall
  '';

  meta = {
    description = "Tool for forensic file system reconstruction";
    homepage = "https://github.com/Lazza/RecuperaBit";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "recuperabit";
  };
}
