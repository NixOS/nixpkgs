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
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = "pymol-open-source";
    rev = "v${version}";
    hash = "sha256-GhTHxacjGN7XklZ6gileBMRZAGq4Pp4JknNL+qGqrVE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "self.install_libbase" '"${placeholder "out"}/${python3.sitePackages}"'
  '';

  build-system = [
    python3Packages.setuptools
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  buildInputs = [ python3Packages.numpy python3Packages.pyqt5 glew glm libpng libxml2 freetype msgpack netcdf ];
  env.NIX_CFLAGS_COMPILE = "-I ${libxml2.dev}/include/libxml2";
  hardeningDisable = [ "format" ];

  postInstall = with python3Packages; ''
    wrapProgram $out/bin/pymol \
      --prefix PYTHONPATH : ${lib.makeSearchPathOutput "lib" python3.sitePackages [ pyqt5 pyqt5.pyqt5-sip ]}

    mkdir -p "$out/share/icons/"
    ln -s $out/${python3.sitePackages}/pymol/pymol_path/data/pymol/icons/icon2.svg "$out/share/icons/pymol.svg"
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    cp -r "${desktopItem}/share/applications/" "$out/share/"
  '';

  preFixup = ''
    wrapQtApp "$out/bin/pymol"
  '';

  meta = with lib; {
    inherit description;
    mainProgram = "pymol";
    homepage = "https://www.pymol.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ samlich ];
  };
}
