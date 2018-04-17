{ stdenv
, makeWrapper
, fetchurl
, intltool
, python3Packages
, gobjectIntrospection
, gtk3
, dbus
, libwnck3
, keybinder3
, hicolor-icon-theme
, wrapGAppsHook
}:

with python3Packages;

buildPythonApplication rec {
  name = "kupfer-${version}";
  version = "319";

  src = fetchurl {
    url = "https://github.com/kupferlauncher/kupfer/releases/download/v${version}/kupfer-v${version}.tar.xz";
    sha256 = "0c9xjx13r8ckfr4az116bhxsd3pk78v04c3lz6lqhraak0rp4d92";
  };

  nativeBuildInputs = [
    wrapGAppsHook intltool
    # For setup hook
    gobjectIntrospection
  ];
  buildInputs = [ hicolor-icon-theme docutils libwnck3 keybinder3 ];
  propagatedBuildInputs = [ pygobject3 gtk3 pyxdg dbus-python pycairo ];

  configurePhase = ''
    runHook preConfigure
    python ./waf configure --prefix=$prefix
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    python ./waf
    runHook postBuild
  '';

  installPhase = let
    pythonPath = (stdenv.lib.concatMapStringsSep ":"
      (m: "${m}/lib/${python.libPrefix}/site-packages")
      propagatedBuildInputs);
  in ''
    runHook preInstall
    python ./waf install

    gappsWrapperArgs+=(
      "--prefix" "PYTHONPATH" : "${pythonPath}"
      "--set" "PYTHONNOUSERSITE" "1"
    )

    runHook postInstall
  '';

  doCheck = false; # no tests

  meta = with stdenv.lib; {
    description = "A smart, quick launcher";
    homepage    = "https://kupferlauncher.github.io/";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ cobbal ];
    platforms   = platforms.linux;
  };
}
