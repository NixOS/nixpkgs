{
  lib,
  intel-cmt-cat,
  fetchFromGitLab,
  python3,
}:
python3.pkgs.buildPythonApplication {
  pname = "pqos-wrapper";
  version = "unstable-2022-01-31";
  pyproject = true;

  src = fetchFromGitLab {
    group = "sosy-lab";
    owner = "software";
    repo = "pqos-wrapper";
    rev = "ce816497a07dcb4b931652b98359e4601a292b15";
    hash = "sha256-SaYr6lVucpJjVtGgxRbDGYbOoBwdfEDVKtvD+M1L0o4=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  makeWrapperArgs = [ "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ intel-cmt-cat ]}" ];

  pythonImportsCheck = [ "pqos_wrapper" ];

  meta = with lib; {
    description = "Wrapper for Intel PQoS for the purpose of using it in BenchExec";
    homepage = "https://gitlab.com/sosy-lab/software/pqos-wrapper";
    maintainers = with maintainers; [ lorenzleutgeb ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "pqos_wrapper";
  };
}
