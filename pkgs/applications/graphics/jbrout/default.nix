{ stdenv, fetchsvn, buildPythonPackage, python, pyGtkGlade, makeWrapper, pyexiv2, lxml, pil, fbida, which }:

buildPythonPackage {
  name = "jbrout-338";
  version = "338";
  src = fetchsvn {
    url = "http://jbrout.googlecode.com/svn/trunk";
    rev = "338";
    sha256 = "0257ni4vkxgd0qhs73fw5ppw1qpf11j8fgwsqc03b1k1yv3hk4hf";
  };

  doCheck = false;
# XXX: preConfigure to avoid this
#  File "/nix/store/vnyjxn6h3rbrn49m25yyw7i1chlxglhw-python-2.7.1/lib/python2.7/zipfile.py", line 348, in FileHeader
#    len(filename), len(extra))
#struct.error: ushort format requires 0 <= number <= USHRT_MAX

  preConfigure = ''
    find | xargs touch
  '';

  postInstall = ''
    mkdir -p $out/bin
    echo '#!/bin/sh' > $out/bin/jbrout
    echo "python $out/lib/python2.7/site-packages/jbrout-src-py2.7.egg/jbrout/jbrout.py" >> $out/bin/jbrout
    chmod +x $out/bin/jbrout

    wrapProgram $out/bin/jbrout \
            --set PYTHONPATH "$out/lib/python:$(toPythonPath ${pyGtkGlade})/gtk-2.0:$(toPythonPath ${pyexiv2}):$(toPythonPath ${lxml}):$(toPythonPath ${pil}):$PYTHONPATH" \
            --set PATH "${fbida}/bin:${which}/bin:$PATH"
  '';

  buildInputs = [ python pyGtkGlade makeWrapper pyexiv2 lxml pil fbida which ];
  meta = {
    homepage = "http://code.google.com/p/jbrout";
    description = "jBrout is a photo manager";
    platforms = stdenv.lib.platforms.linux;
  };
}
