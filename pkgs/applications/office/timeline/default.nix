{ lib
, fetchurl
, python3
, gettext
, makeDesktopItem
, copyDesktopItems
}:

python3.pkgs.buildPythonApplication rec {
  pname = "timeline";
  version = "2.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/thetimelineproj/${pname}-${version}.zip";
    sha256 = "1pa0whqci6c2p20xf7gbndrrpr1xg42ixhql595ibdd4p3l37v23";
  };

  nativeBuildInputs = [ python3.pkgs.wrapPython copyDesktopItems ];

  pythonPath = with python3.pkgs; [
    wxPython_4_0 # not compatible with wxPython_4_1. reported upstream https://github.com/wxWidgets/Phoenix/issues/1956
    humblewx
    icalendar
    markdown
    pysvg-py3
    pillow
  ];

  checkInputs = [
    gettext
    python3.pkgs.mock
  ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Timeline";
      name = "timeline";
      comment = "Display and navigate information on a timeline";
      icon = "timeline";
      terminal = false;
      exec = "timeline";
      categories = "Office;Calendar;";
    })
  ];

  dontBuild = true;
  doCheck = false;

  patchPhase = ''
    sed -i "s|_ROOT =.*|_ROOT = \"$out/usr/share/timeline/\"|" source/timelinelib/config/paths.py
  '';

  installPhase = ''
    runHook preInstall

    site_packages=$out/${python3.pkgs.python.sitePackages}
    install -D -m755 source/timeline.py $out/bin/timeline
    mkdir -p $site_packages
    cp -r source/timelinelib $site_packages/

    mkdir -p $out/usr/share/timeline/locale
    cp -r icons $out/usr/share/timeline/
    cp -r translations/ $out/usr/share/timeline/

    mkdir -p $out/share/icons/hicolor/{48x48,32x32,16x16}/apps
    cp icons/48.png $out/share/icons/hicolor/48x48/apps/timeline.png
    cp icons/32.png $out/share/icons/hicolor/32x32/apps/timeline.png
    cp icons/16.png $out/share/icons/hicolor/16x16/apps/timeline.png

    runHook postInstall
  '';

  # tests fail because they need an x server
  # Unable to access the X Display, is $DISPLAY set properly?
  checkPhase = ''
    runHook preCheck
    ${python3.interpreter} tools/execute-specs.py
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "http://thetimelineproj.sourceforge.net/";
    changelog = "http://thetimelineproj.sourceforge.net/changelog.html";
    description = "Display and navigate information on a timeline";
    license = with licenses; [ gpl3Only cc-by-sa-30 ];
    platforms = with platforms; unix;
    maintainers = with maintainers; [ davidak ];
  };
}
