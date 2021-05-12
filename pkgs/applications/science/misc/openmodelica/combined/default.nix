{stdenv, lib, openmodelica, symlinkJoin, gnumake, openblas, makeWrapper}:
with openmodelica;
symlinkJoin {
  name = "openmodelica-combined";
  paths = [omcompiler omsimulator omplot omparser omedit omlibrary];

  buildInputs = [gnumake makeWrapper];

  postBuild = ''
    wrapProgram $out/bin/OMEdit \
      --prefix PATH : "${gnumake}/bin" \
      --prefix PATH : "${stdenv.cc}/bin" \
      --prefix LIBRARY_PATH : "${lib.makeLibraryPath [openblas]}" \
      --set-default OPENMODELICALIBRARY "${omlibrary}/lib/omlibrary"
    '';
}

