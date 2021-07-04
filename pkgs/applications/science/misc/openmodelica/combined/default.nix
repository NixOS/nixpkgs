{ stdenv, lib, openmodelica, symlinkJoin, gnumake, blas, lapack, makeWrapper }:
symlinkJoin {
  name = "openmodelica-combined";
  paths = with openmodelica; [
    omcompiler
    omsimulator
    omplot
    omparser
    omedit
    omlibrary
    omshell
  ];

  buildInputs = [ gnumake makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/OMEdit \
      --prefix PATH : ${lib.makeBinPath [ gnumake stdenv.cc ]} \
      --prefix LIBRARY_PATH : "${lib.makeLibraryPath [ blas lapack ]}" \
      --set-default OPENMODELICALIBRARY "${openmodelica.omlibrary}/lib/omlibrary"
  '';
}
