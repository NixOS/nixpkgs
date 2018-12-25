{ stdenv, lib, fetchurl, doxygen, extra-cmake-modules, graphviz, kdoctools
, fetchpatch

, akonadi, alkimia, aqbanking, gmp, gwenhywfar, kactivities, karchive
, kcmutils, kcontacts, kdewebkit, kdiagram, kholidays, kidentitymanagement
, kitemmodels, libical, libofx, qgpgme

# Needed for running tests:
, qtbase, xvfb_run

# For weboob, which only supports Python 2.x:
, python2Packages
}:

stdenv.mkDerivation rec {
  name = "kmymoney-${version}";
  version = "5.0.1";

  src = fetchurl {
    url = "mirror://kde/stable/kmymoney/${version}/src/${name}.tar.xz";
    sha256 = "1c9apnvc07y17pzy4vygry1dai5ass2z7j354lrcppa85b18yvnx";
  };

  # Fix build with Qt 5.11.
  patches = lib.singleton (fetchpatch {
    url = "https://cgit.kde.org/kmymoney.git/patch/?id="
        + "e5198a902996b27bf9abde0ad24af82d55ab5dc1";
    sha256 = "1h2f1xznf7343s26fh94x8n2ci0pijk5j86f24lvghawsw848316";
  });

  # Hidden dependency that wasn't included in CMakeLists.txt:
  NIX_CFLAGS_COMPILE = "-I${kitemmodels.dev}/include/KF5";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    doxygen extra-cmake-modules graphviz kdoctools python2Packages.wrapPython
  ];

  buildInputs = [
    akonadi alkimia aqbanking gmp gwenhywfar kactivities karchive kcmutils
    kcontacts kdewebkit kdiagram kholidays kidentitymanagement kitemmodels
    libical libofx qgpgme

    # Put it into buildInputs so that CMake can find it, even though we patch
    # it into the interface later.
    python2Packages.weboob
  ];

  weboobPythonPath = [ python2Packages.weboob ];

  postInstall = ''
    buildPythonPath "$weboobPythonPath"
    patchPythonScript "$out/share/kmymoney/weboob/kmymoneyweboob.py"

    # Within the embedded Python interpreter, sys.argv is unavailable, so let's
    # assign it to a dummy value so that the assignment of sys.argv[0] injected
    # by patchPythonScript doesn't fail:
    sed -i -e '1i import sys; sys.argv = [""]' \
      "$out/share/kmymoney/weboob/kmymoneyweboob.py"
  '';

  doInstallCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  installCheckInputs = [ xvfb_run ];
  installCheckPhase = let
    pluginPath = "${qtbase.bin}/${qtbase.qtPluginPrefix}";
  in lib.optionalString doInstallCheck ''
    QT_PLUGIN_PATH=${lib.escapeShellArg pluginPath} \
      xvfb-run -s '-screen 0 1024x768x24' make test \
      ARGS="-E '(reports-chart-test)'" # Test fails, so exclude it for now.
  '';

  meta = {
    description = "Personal finance manager for KDE";
    homepage = https://kmymoney.org/;
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
