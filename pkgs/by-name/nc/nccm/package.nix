{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "nccm";
  version = "1.3.0";
  format = "other";
  src = fetchFromGitHub {
    owner = "flyingrhinonz";
    repo = "nccm";
    rev = version;
    hash = "sha256-1leAyYrkilPjHt3R6AKtGXBDmXfERpH8Y4BhzToGWEs=";
  };
  propagatedBuildInputs = with python3.pkgs; [ pyyaml ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp nccm/nccm $out/bin

    runHook postInstall
  '';

  meta = {
    mainProgram = "nccm";
    maintainers = with lib.maintainers; [ antonmosich ];
    license = lib.licenses.gpl3;
    description = "Simple yet powerful ncurses ssh connection manager";
    homepage = "https://github.com/flyingrhinonz/nccm";
  };
}
