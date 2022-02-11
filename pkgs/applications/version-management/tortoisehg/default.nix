{ lib
, fetchurl
, python3Packages
, mercurial
, qt5
}:

python3Packages.buildPythonApplication rec {
  pname = "tortoisehg";
  version = "6.0";

  src = fetchurl {
    url = "https://www.mercurial-scm.org/release/tortoisehg/targz/tortoisehg-${version}.tar.gz";
    sha256 = "sha256-25uQ2llF/+wqdGpun/nzlvAf286OIRmlZUISZ0szH6Y=";
  };

  # Extension point for when thg's mercurial is lagging behind mainline.
  tortoiseMercurial = mercurial;

  propagatedBuildInputs = with python3Packages; [
    tortoiseMercurial
    qscintilla-qt5
    iniparse
  ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  doCheck = true;
  postInstall = ''
    mkdir -p $out/share/doc/tortoisehg
    cp COPYING.txt $out/share/doc/tortoisehg/Copying.txt
    # convenient alias
    ln -s $out/bin/thg $out/bin/tortoisehg
    wrapQtApp $out/bin/thg
  '';

  checkPhase = ''
    export QT_QPA_PLATFORM=offscreen
    echo "test: thg smoke test"
    $out/bin/thg -h > help.txt &
    sleep 1s
    if grep "list of commands" help.txt; then
      echo "thg help output was captured. Seems like package in a working state."
      exit 0
    else
      echo "thg help output was not captured. Seems like package is broken."
      exit 1
    fi
  '';

  passthru.mercurial = tortoiseMercurial;

  meta = {
    description = "Qt based graphical tool for working with Mercurial";
    homepage = "https://tortoisehg.bitbucket.io/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ danbst ];
  };
}
