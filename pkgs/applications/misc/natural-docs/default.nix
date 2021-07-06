{ stdenv, fetchzip, makeWrapper, mono, lib }:

stdenv.mkDerivation rec {
  pname = "natural-docs";
  version = "2.1.1";

  src = fetchzip {
    url = "https://naturaldocs.org/download/natural_docs/${version}/Natural_Docs_${version}.zip";
    sha256 = "03fizjgvhiw3lqyykqw1whdh97xyiy3f226c1348ll61ryjxamqw";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r . $out/
    makeWrapper ${mono}/bin/mono $out/bin/NaturalDocs --add-flags "$out/NaturalDocs.exe"
  '';

  meta = with lib; {
    description = "Documentation generator for multiple programming languages.";
    longDescription = ''
      Natural Docs is an open source documentation generator for multiple
      programming languages. You document your code in a natural syntax that
      reads like plain English. Natural Docs then scans your code and builds
      high-quality HTML documentation from it.
    '';
    homepage = "https://naturaldocs.org";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.nkpvk ];
  };
}
