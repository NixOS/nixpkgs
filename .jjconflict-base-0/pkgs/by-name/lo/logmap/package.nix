{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "logmap";
  version = "unstable-2021-12-15";
  format = "other";

  src = fetchFromGitHub {
    owner = "zhzyker";
    repo = pname;
    rev = "5040707b4ae260830072de93ccd6a23615073abf";
    sha256 = "sha256-LOGjK5l/gaKObWbC9vaLruE8DdDsabztnEW/TjvCdtE=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests
  ];

  installPhase = ''
    runHook preInstall
    install -vD ${pname}.py $out/bin/${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tools for fuzzing Log4j2 jndi injection";
    homepage = "https://github.com/zhzyker/logmap";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "logmap";
  };
}
