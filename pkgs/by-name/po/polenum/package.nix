{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "polenum";
  version = "1.7";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Wh1t3Fox";
    repo = "polenum";
    tag = finalAttrs.version;
    hash = "sha256-/xjGwolpbkh/ig0N9gpSTQMIJ/2ayThRBzx3tF1kfjM=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    impacket
  ];

  installPhase = ''
    runHook preInstall

    install -vD $pname.py $out/bin/$pname

    runHook postInstall
  '';

  meta = {
    description = "Tool to get the password policy from a windows machine";
    homepage = "https://github.com/Wh1t3Fox/polenum";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ exploitoverload ];
    mainProgram = "polenum";
  };
})
