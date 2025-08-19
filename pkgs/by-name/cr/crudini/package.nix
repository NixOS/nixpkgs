{
  lib,
  fetchFromGitHub,
  python3Packages,
  help2man,
  installShellFiles,
}:

python3Packages.buildPythonApplication rec {
  pname = "crudini";
  version = "0.9.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pixelb";
    repo = "crudini";
    tag = version;
    hash = "sha256-XW9pdP+aie6v9h35gLYM0wVrcsh+dcEB7EueATOV4w4=";
  };

  postPatch = ''
    patchShebangs crudini.py crudini-help tests/test.sh
  '';

  nativeBuildInputs = [
    help2man
    installShellFiles
    python3Packages.setuptools
    python3Packages.setuptools-scm
    python3Packages.wheel
  ];

  propagatedBuildInputs = with python3Packages; [ iniparse ];

  postInstall = ''
    # this just creates the man page
    make all

    install -Dm444 -t $out/share/doc/${pname} README.md EXAMPLES
    installManPage *.1
  '';

  checkPhase = ''
    runHook preCheck

    pushd tests >/dev/null
    ./test.sh
    popd >/dev/null

    runHook postCheck
  '';

  meta = with lib; {
    description = "Utility for manipulating ini files";
    homepage = "https://www.pixelbeat.org/programs/crudini/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "crudini";
  };
}
