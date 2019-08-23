{ stdenv, fetchsvn, pythonPackages, makeWrapper, fbida, which }:

let
  inherit (pythonPackages) python;
in pythonPackages.buildPythonApplication rec {
  name = "jbrout-${version}";
  version = "338";

  src = fetchsvn {
    url = "http://jbrout.googlecode.com/svn/trunk";
    rev = version;
    sha256 = "0257ni4vkxgd0qhs73fw5ppw1qpf11j8fgwsqc03b1k1yv3hk4hf";
  };

  doCheck = false;

  # XXX: patchPhase to avoid this
  #  File "/nix/store/vnyjxn6h3rbrn49m25yyw7i1chlxglhw-python-2.7.1/lib/python2.7/zipfile.py", line 348, in FileHeader
  #    len(filename), len(extra))
  #struct.error: ushort format requires 0 <= number <= USHRT_MAX
  patchPhase = ''
    find | xargs touch

    substituteInPlace setup.py --replace "version=__version__" "version=baseVersion"
  '';

  postInstall = ''
    mkdir $out/bin
    echo "python $out/${python.sitePackages}/jbrout/jbrout.py" > $out/bin/jbrout
    chmod +x $out/bin/jbrout
  '';

  buildInputs = [ python makeWrapper which ];
  propagatedBuildInputs = with pythonPackages; [ pillow lxml pyGtkGlade pyexiv2 fbida ];

  meta = {
    homepage = https://manatlan.com/jbrout/;
    description = "Photo manager";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
