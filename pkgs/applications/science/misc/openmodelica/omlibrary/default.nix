{
  lib,
  fetchzip,
  zip,
  openmodelica,
  mkOpenModelicaDerivation,
}:
let
  # The openmodelica package cache only takes correctly named zip files
  fetchzipRepack = r: ''
    ln -s "${fetchzip (builtins.removeAttrs r [ "folderName" ])}" "${r.folderName}"
    ${zip}/bin/zip -0 -r $out/.openmodelica/cache/$(basename ${r.url}) "${r.folderName}"
  '';
in
mkOpenModelicaDerivation {
  pname = "omlibrary";
  omdir = "libraries";
  omtarget = "omlibrary";
  omdeps = [ openmodelica.omcompiler ];

  postPatch = with openmodelica; ''
    sed -i libraries/Makefile -e '
      s|../../build/bin/omc|${omcompiler}/bin/omc|
      s|../build/bin/omc|${omcompiler}/bin/omc|
      s|cp index.json.*|cp -f index.json $(out)/.openmodelica/libraries/index.json|
      s|cp install-index.json.*|cp -f install-index.json $(out)/.openmodelica/libraries/index.json|
      s|installing/.openmodelica/cache|$(out)/.openmodelica/cache|
    '
    export HOME=$out
    sed -i libraries/install-index.mos -e 's|OpenModelica.Scripting.cd()|getEnvironmentVar("out")|g'
    sed -i libraries/index.mos -e 's|OpenModelica.Scripting.cd()|getEnvironmentVar("out")|g'
    mkdir -p $out/.openmodelica/libraries
    mkdir -p $out/.openmodelica/cache
    ${lib.concatMapStrings fetchzipRepack (import ./src-libs.nix)}
  '';

  meta = with lib; {
    description = "Collection of Modelica libraries to use with OpenModelica,
including Modelica Standard Library";
    homepage = "https://openmodelica.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      balodja
      smironov
    ];
    platforms = platforms.linux;
  };
}
