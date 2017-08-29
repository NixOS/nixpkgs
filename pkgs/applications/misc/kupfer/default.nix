{ lib
, stdenv
, makeWrapper
, fetchurl
, intltool
, python3Packages
, gtk3
, dbus
, libwnck3
, keybinder3
, hicolor_icon_theme
}:

let inherit (python3Packages) mkPythonDerivation pygobject3 pyxdg dbus-python docutils;
in  mkPythonDerivation rec {
  name = "kupfer-${version}";
  version = "319";
  # Since this is an application, don't prefix it with python3.x-
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/kupferlauncher/kupfer/releases/download/v${version}/kupfer-v${version}.tar.xz";
    sha256 = "0c9xjx13r8ckfr4az116bhxsd3pk78v04c3lz6lqhraak0rp4d92";
  };

  buildInputs = [ intltool hicolor_icon_theme docutils ];
  propagatedBuildInputs = [ pygobject3 gtk3 pyxdg dbus dbus-python libwnck3 keybinder3 ];

  configurePhase = ''
    ./waf configure --prefix=$prefix
  '';

  buildPhase = ''
    ./waf
  '';

  installPhase = ''
    ./waf install

    # TODO: we're capturing unneeded build inputs here...
    wrapProgram $out/bin/kupfer \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix PYTHONPATH : "$PYTHONPATH" \
        --set PYTHONNOUSERSITE 1
  '';

  meta = with lib; {
    description = "A smart, quick launcher";
    homepage    = "https://kupferlauncher.github.io/";
    license     = licenses.gpl3;
  };
}
