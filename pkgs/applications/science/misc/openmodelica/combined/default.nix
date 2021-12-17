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

  meta = with lib; {
    description = "An open-source Modelica-based modeling and simulation environment intended for industrial and academic usage";
    homepage = "https://openmodelica.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ balodja smironov ];
    platforms = platforms.linux;
  };
}
