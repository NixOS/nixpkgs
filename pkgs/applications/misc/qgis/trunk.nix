{qgis, fetchurl,  sourceFromHead, python, sip}:
qgis.merge {

  name = "qgis-trunk";

  buildInputs = [ sip python ];

  preConfigure = ''
    export PYTHONPATH=$(toPythonPath ${sip})
  '';

  cfgOption = [
                # without this option it can't find sqlite libs yet (missing symbols..) (TODO)
                "-DWITH_INTERNAL_SQLITE3=TRUE"
                "-DPYTHON_EXECUTABLE=${python}/bin/python"
              ];

  # REGION AUTO UPDATE:    { name="qgis"; type="svn"; url="https://svn.osgeo.org/qgis/trunk/qgis"; }
  src = sourceFromHead "qgis-13572.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/qgis-13572.tar.gz"; sha256 = "fd4c0e19919901cbee7ead7522acdbecbf17c5b9050e34ef91f8ea6e2736bec8"; });
  # END

}
