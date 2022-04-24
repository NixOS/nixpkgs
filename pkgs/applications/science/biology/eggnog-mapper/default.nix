{ lib
, autoPatchelfHook
, fetchFromGitHub
, python3Packages
, wget
, zlib
}:

python3Packages.buildPythonApplication rec {
  pname = "eggnog-mapper";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "eggnogdb";
    repo = pname;
    rev = version;
    hash = "sha256-auVD/r8m3TAB1KYMQ7Sae23eDg6LRx/daae0505cjwU=";
  };

  postPatch = ''
    # Not a great solution...
    substituteInPlace setup.cfg \
      --replace "==" ">="
  '';

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = [
    wget
  ] ++ (with python3Packages; [
    biopython
    psutil
    XlsxWriter
  ]);

  # Tests rely on some of the databases being available, which is not bundled
  # with this package as (1) in total, they represent >100GB of data, and (2)
  # the user can download only those that interest them.
  doCheck = false;

  meta = with lib; {
    description = "Fast genome-wide functional annotation through orthology assignment";
    license = licenses.gpl2;
    homepage = "https://github.com/eggnogdb/eggnog-mapper/wiki";
    maintainers = with maintainers; [ luispedro ];
    platforms = platforms.all;
  };
}
