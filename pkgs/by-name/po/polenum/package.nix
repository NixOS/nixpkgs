{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "polenum";
  version = "1.6.1-unstable-2024-07-30";
  format = "other";

  src = fetchFromGitHub {
    owner = "Wh1t3Fox";
    repo = "polenum";
    rev = "6f95ce0f9936d8c20820e199a4bb1ea68d2f061f";
    hash = "sha256-aCX7dByfkUSFHjhRAjrFhbbeIgYNGixnB5pHE/lftng=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    impacket
  ];

  installPhase = ''
    runHook preInstall

    install -vD $pname.py $out/bin/$pname

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to get the password policy from a windows machine";
    homepage = "https://github.com/Wh1t3Fox/polenum";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ exploitoverload ];
    mainProgram = "polenum";
  };
}
