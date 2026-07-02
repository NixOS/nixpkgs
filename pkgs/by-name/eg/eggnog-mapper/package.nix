{
  lib,
  autoPatchelfHook,
  fetchFromGitHub,
  python3Packages,
  wget,
  zlib,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "eggnog-mapper";
  version = "2.1.13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "eggnogdb";
    repo = "eggnog-mapper";
    tag = finalAttrs.version;
    hash = "sha256-Gu4D8DBvgCPlO+2MjeNZy6+lNqsIlksegWmmYvEZmUU=";
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
  ]
  ++ (with python3Packages; [
    biopython
    psutil
    xlsxwriter
  ]);

  # Tests rely on some of the databases being available, which is not bundled
  # with this package as (1) in total, they represent >100GB of data, and (2)
  # the user can download only those that interest them.
  doCheck = false;

  meta = {
    description = "Fast genome-wide functional annotation through orthology assignment";
    license = lib.licenses.gpl2;
    homepage = "https://github.com/eggnogdb/eggnog-mapper/wiki";
    maintainers = with lib.maintainers; [ luispedro ];
    platforms = lib.platforms.all;
  };
})
