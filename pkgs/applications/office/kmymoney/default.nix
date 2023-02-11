{ stdenv, lib, fetchurl, doxygen, extra-cmake-modules, graphviz, kdoctools
, wrapQtAppsHook
, autoPatchelfHook

, akonadi, alkimia, aqbanking, gmp, gwenhywfar, kactivities, karchive
, kcmutils, kcontacts, qtwebengine, kdiagram, kholidays, kidentitymanagement
, kitemmodels, libical, libofx, qgpgme

, sqlcipher

# Needed for running tests:
, xvfb-run

, python3
}:

stdenv.mkDerivation rec {
  pname = "kmymoney";
  version = "5.1.3";

  src = fetchurl {
    url = "mirror://kde/stable/kmymoney/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "sha256-OTi4B4tzkboy4Su0I5di+uE0aDoMLsGnUQXDAso+Xj8=";
  };

  cmakeFlags = [
    # Remove this when upgrading to a KMyMoney release that includes
    # https://invent.kde.org/office/kmymoney/-/merge_requests/118
    "-DENABLE_WEBENGINE=ON"
  ];

  # Hidden dependency that wasn't included in CMakeLists.txt:
  NIX_CFLAGS_COMPILE = "-I${kitemmodels.dev}/include/KF5";

  nativeBuildInputs = [
    doxygen extra-cmake-modules graphviz kdoctools
    python3.pkgs.wrapPython wrapQtAppsHook autoPatchelfHook
  ];

  buildInputs = [
    akonadi alkimia aqbanking gmp gwenhywfar kactivities karchive kcmutils
    kcontacts qtwebengine kdiagram kholidays kidentitymanagement kitemmodels
    libical libofx qgpgme
    sqlcipher

    # Put it into buildInputs so that CMake can find it, even though we patch
    # it into the interface later.
    python3.pkgs.woob
  ];

  postPatch = ''
    buildPythonPath "${python3.pkgs.woob}"
    patchPythonScript "kmymoney/plugins/woob/interface/kmymoneywoob.py"

    # Within the embedded Python interpreter, sys.argv is unavailable, so let's
    # assign it to a dummy value so that the assignment of sys.argv[0] injected
    # by patchPythonScript doesn't fail:
    sed -i -e '1i import sys; sys.argv = [""]' \
      "kmymoney/plugins/woob/interface/kmymoneywoob.py"
  '';

  doInstallCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  nativeInstallCheckInputs = [ xvfb-run ];
  installCheckPhase =
    lib.optionalString doInstallCheck ''
      xvfb-run -s '-screen 0 1024x768x24' make test \
        ARGS="-E '(reports-chart-test)'" # Test fails, so exclude it for now.
    '';

  # libpython is required by the python interpreter embedded in kmymoney, so we
  # need to explicitly tell autoPatchelf about it.
  postFixup = ''
    patchelf --debug --add-needed libpython${python3.pythonVersion}.so \
      "$out/bin/.kmymoney-wrapped"
  '';

  meta = {
    description = "Personal finance manager for KDE";
    homepage = "https://kmymoney.org/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ aidalgol das-g ];
  };
}
