{
  stdenv,
  fetchzip,
  makeWrapper,
  mono,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "natural-docs";
  version = "2.3.1";

  src = fetchzip {
    url = "https://naturaldocs.org/download/natural_docs/${finalAttrs.version}/Natural_Docs_${finalAttrs.version}.zip";
    sha256 = "sha256-gjAhS2hdFA8G+E5bJD18BQdb7PrBeRnpBBSlnVJ5hgY=";
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

  meta = {
    description = "Documentation generator for multiple programming languages";
    longDescription = ''
      Natural Docs is an open source documentation generator for multiple
      programming languages. You document your code in a natural syntax that
      reads like plain English. Natural Docs then scans your code and builds
      high-quality HTML documentation from it.
    '';
    homepage = "https://naturaldocs.org";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.nkpvk ];
    mainProgram = "NaturalDocs";
  };
})
