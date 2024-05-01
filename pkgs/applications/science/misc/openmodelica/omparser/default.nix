{
  lib,
  pkg-config,
  jre8,
  libuuid,
  openmodelica,
  mkOpenModelicaDerivation,
}:

mkOpenModelicaDerivation {
  pname = "omparser";
  omdir = "OMParser";
  omdeps = [ openmodelica.omcompiler ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    jre8
    libuuid
  ];

  postPatch = ''
    sed -i 's|omparser.skip:|omparser.skip: build-dirs|g' Makefile.in
    cat ${./build-dirs.txt} >> Makefile.in
    # put the parser header files somewhere dependents can find
    sed -i OMParser/Makefile -e '
      s|$(OMBUILDDIR)/include/omc/|$(OMBUILDDIR)/include/omc/c/|
      s|cp -pR|cp $(H_FILES) $(OMBUILDDIR)/include/omc/c/\n\tcp -pR|
    '
  '';

  meta = with lib; {
    description = "Antlr4-based parser of Modelica files from OpenModelica
suite";
    homepage = "https://openmodelica.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      balodja
      smironov
    ];
    platforms = platforms.linux;
  };
}
