{ lib, stdenv, fetchurl, fetchFromGitHub, makeDesktopItem
, python3, python3Packages
, glew, glm, freeglut, libpng, libxml2, tk, freetype, msgpack }:


let
  pname = "pymol";
  description = "A Python-enhanced molecular graphics tool";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    desktopName = "PyMol Molecular Graphics System";
    genericName = "Molecular Modeler";
    comment = description;
    mimeType = "chemical/x-pdb;chemical/x-mdl-molfile;chemical/x-mol2;chemical/seq-aa-fasta;chemical/seq-na-fasta;chemical/x-xyz;chemical/x-mdl-sdf;";
    categories = "Graphics;Education;Science;Chemistry;";
  };
in
python3Packages.buildPythonApplication rec {
  inherit pname;
  version = "2.3.0";
  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = "pymol-open-source";
    rev = "v${version}";
    sha256 = "175cqi6gfmvv49i3ws19254m7ljs53fy6y82fm1ywshq2h2c93jh";
  };

  buildInputs = [ python3Packages.numpy glew glm freeglut libpng libxml2 tk freetype msgpack ];
  NIX_CFLAGS_COMPILE = "-I ${libxml2.dev}/include/libxml2 -Wno-error=format-security";

  setupPyBuildFlags = [ "--glut" ];

  installPhase = ''
    python setup.py install --home=$out
    cp -r ${desktopItem}/share/ $out/
    runHook postInstall
  '';

  postInstall = with python3Packages; ''
    wrapProgram $out/bin/pymol \
      --prefix PYTHONPATH : ${lib.makeSearchPathOutput "lib" python3.sitePackages [ Pmw tkinter ]}
  '';

  meta = {
    description = description;
    homepage = https://www.pymol.org/;
    license = lib.licenses.psfl;
  };
}
