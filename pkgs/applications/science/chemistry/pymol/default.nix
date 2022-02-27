{ lib
, fetchFromGitHub
, makeDesktopItem
, python3
, python3Packages
, netcdf
, glew
, glm
, freeglut
, libpng
, libxml2
, tk
, freetype
, msgpack
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

  buildInputs = [ python3Packages.numpy glew glm freeglut libpng libxml2 tk freetype msgpack netcdf ];
  NIX_CFLAGS_COMPILE = "-I ${libxml2.dev}/include/libxml2";
  hardeningDisable = [ "format" ];

  setupPyBuildFlags = [ "--glut" ];

  installPhase = ''
    python setup.py install --home="$out"
    runHook postInstall
  '';

  postInstall = with python3Packages; ''
    wrapProgram $out/bin/pymol \
      --prefix PYTHONPATH : ${lib.makeSearchPathOutput "lib" python3.sitePackages [ Pmw tkinter ]}

    mkdir -p "$out/share/icons/"
    ln -s ../../lib/python/pymol/pymol_path/data/pymol/icons/icon2.svg "$out/share/icons/pymol.svg"
    cp -r "${desktopItem}/share/applications/" "$out/share/"
  '';

  meta = with lib; {
    inherit description;
    homepage = "https://www.pymol.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ samlich ];
  };
}
