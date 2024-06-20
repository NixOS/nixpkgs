{
  lib,
  stdenvNoCC,
  python3,
  fetchFromGitHub,
}: let
  runtimePython = python3.withPackages (pythonPackages:
    with pythonPackages; [
      click
    ]);
in
  stdenvNoCC.mkDerivation rec {
    pname = "lutris-humble-cookies";
    version = "unreleased";

    src = fetchFromGitHub {
      owner = "rcrit";
      repo = pname;
      rev = "cc1dd6c50cc7181370f64848642be9681b87a1d8";
      hash = "sha256-AsANi5KjohVV+Iv3sN3AlMq3f+hDOWmotY4+Ku+t358=";
    };

    patchPhase = ''
      substituteInPlace extract_cookies.py --replace '/usr/bin/python3' '${runtimePython.interpreter}'
   '';

    doCheck = false;

    installPhase = ''
      install -Dm755 extract_cookies.py $out/bin/extract_cookies.py
    '';

    meta = with lib; {
      mainProgram = "extract_cookies.py";
      description = "Helper script to transfer Humble Bundle cookie from Firefox to Lutris";
      homepage = "https://github.com/rcrit/lutris-humble-cookies";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [wamserma];
    };
  }
