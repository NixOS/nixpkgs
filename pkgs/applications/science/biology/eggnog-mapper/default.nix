{ lib
, stdenv
, autoPatchelfHook
, fetchFromGitHub
, python3Packages
, wget
, zlib
}:

python3Packages.buildPythonApplication rec {
  pname = "eggnog-mapper";
  version = "2.1.12";

  src = fetchFromGitHub {
    owner = "eggnogdb";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-+luxXQmtGufYrA/9Ak3yKzbotOj2HM3vhIoOxE+Ty1U=";
  };

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    wget
    zlib
  ];

  propagatedBuildInputs = with python3Packages; [
    biopython
    psutil
    xlsxwriter
  ];

  pythonRelaxDeps = true;

  # Tests rely on some of the databases being available, which is not bundled
  # with this package as (1) in total, they represent >100GB of data, and (2)
  # the user can download only those that interest them.
  doCheck = false;

  meta = with lib; {
    description = "Fast genome-wide functional annotation through orthology assignment";
    license = licenses.agpl3Only;
    homepage = "https://github.com/eggnogdb/eggnog-mapper/wiki";
    changelog = "https://github.com/eggnogdb/eggnog-mapper/releases/tag/${src.rev}";
    maintainers = with maintainers; [ luispedro ];
  };
}
