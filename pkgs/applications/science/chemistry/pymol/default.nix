{ stdenv
, lib
, fetchFromGitHub
, makeDesktopItem
, python3
, python3Packages
, netcdf
, glew
, glm
, libpng
, libxml2
, freetype
, msgpack
, qt5
}:
let
  pname = "pymol";
  description = "A Python-enhanced molecular graphics tool";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    desktopName = "PyMol Molecular Graphics System";
    genericName = "Molecular Modeler";
    comment = description;
    icon = pname;
    mimeTypes = [
      "chemical/x-pdb"
      "chemical/x-mdl-molfile"
      "chemical/x-mol2"
      "chemical/seq-aa-fasta"
      "chemical/seq-na-fasta"
      "chemical/x-xyz"
      "chemical/x-mdl-sdf"
    ];
    categories = [ "Graphics" "Education" "Science" "Chemistry" ];
  };
in
python3Packages.buildPythonApplication rec {
  inherit pname;
  version = "2.5.0";
  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = "pymol-open-source";
    rev = "v${version}";
    sha256 = "sha256-JdsgcVF1w1xFPZxVcyS+GcWg4a1Bd4SvxFOuSdlz9SM=";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  buildInputs = [ python3Packages.numpy python3Packages.pyqt5 glew glm libpng libxml2 freetype msgpack netcdf ];
  env.NIX_CFLAGS_COMPILE = "-I ${libxml2.dev}/include/libxml2";
  hardeningDisable = [ "format" ];

  installPhase = ''
    python setup.py install --home="$out"
    runHook postInstall
  '';

  postInstall = with python3Packages; ''
    wrapProgram $out/bin/pymol \
      --prefix PYTHONPATH : ${lib.makeSearchPathOutput "lib" python3.sitePackages [ pyqt5 pyqt5.pyqt5_sip ]}

    mkdir -p "$out/share/icons/"
    ln -s ../../lib/python/pymol/pymol_path/data/pymol/icons/icon2.svg "$out/share/icons/pymol.svg"
    cp -r "${desktopItem}/share/applications/" "$out/share/"
  '';

  preFixup = ''
    wrapQtApp "$out/bin/pymol"
  '';

  meta = with lib; {
    inherit description;
    homepage = "https://www.pymol.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ samlich ];
  };
}
