{ stdenv, fetchurl, makeDesktopItem, python3Packages, glew, freeglut, libpng, libxml2, tk, freetype }:

let
  pname = "pymol";
  ver_maj = "1.8";
  ver_min = "4";
  version = "${ver_maj}.${ver_min}.0";
  description = "A Python-enhanced molecular graphics tool";

  desktopItem = makeDesktopItem {
    name = "${pname}";
    exec = "${pname}";
    desktopName = "PyMol Molecular Graphics System";
    genericName = "Molecular Modeller";
    comment = description;
    mimeType = "chemical/x-pdb;chemical/x-mdl-molfile;chemical/x-mol2;chemical/seq-aa-fasta;chemical/seq-na-fasta;chemical/x-xyz;chemical/x-mdl-sdf;";
    categories = "Graphics;Education;Science;Chemistry;";
  };
in
python3Packages.buildPythonApplication {
  name = "pymol-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/project/pymol/pymol/${ver_maj}/pymol-v${version}.tar.bz2";
    sha256 = "0yfj8g5yic9zz6f0bw2n8h6ifvgsn8qvhq84alixsi28wzppn55n";
  };

  buildInputs = [ python3Packages.numpy glew freeglut libpng libxml2 tk freetype ];
  NIX_CFLAGS_COMPILE = "-I ${libxml2.dev}/include/libxml2";

  installPhase = ''
    python setup.py install --home=$out
    cp -r ${desktopItem}/share/ $out/
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/pymol \
      --prefix PYTHONPATH : ${python3Packages.Pmw}/lib/python3.6/site-packages \
      --prefix PYTHONPATH : ${python3Packages.tkinter}/lib/python3.6/site-packages
  '';

  meta = with stdenv.lib; {
    description = description;
    homepage = "https://www.pymol.org/";
    license = licenses.psfl;
  };
}
