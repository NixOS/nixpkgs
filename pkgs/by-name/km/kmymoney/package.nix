{
  stdenv,
  lib,
  fetchurl,
  cmake,
  doxygen,
  graphviz,
  pkg-config,
  autoPatchelfHook,
  kdePackages,
  alkimia,
  aqbanking,
  gmp,
  gwenhywfar,
  libical,
  libofx,
  sqlcipher,

  # Needed for running tests:
  xvfb-run,

  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmymoney";
  version = "5.2.1";

  src = fetchurl {
    url = "mirror://kde/stable/kmymoney/${finalAttrs.version}/kmymoney-${finalAttrs.version}.tar.xz";
    hash = "sha256-/q30C21MkNd+MnFqhY3SN2kIGGMQTYzqYpELHsPkM2s=";
  };

  cmakeFlags = [
    "-DBUILD_WITH_QT6=1"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
    python3.pkgs.wrapPython
  ]
  ++ (with kdePackages; [
    extra-cmake-modules
    wrapQtAppsHook
    kdoctools
    autoPatchelfHook
  ]);

  buildInputs = [
    alkimia
    aqbanking
    gmp
    gwenhywfar
    libical
    libofx
    sqlcipher
  ]
  ++ (with kdePackages; [
    akonadi
    karchive
    kcmutils
    kcontacts
    qtwebengine
    kdiagram
    kholidays
    kidentitymanagement
    kitemmodels
    plasma-activities
    qgpgme
  ])
  ++ [
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

  # libpython is required by the python interpreter embedded in kmymoney, so we
  # need to explicitly tell autoPatchelf about it.
  postFixup = ''
    patchelf --debug --add-needed libpython${python3.pythonVersion}.so \
      "$out/bin/.kmymoney-wrapped"
  '';

  meta = {
    description = "Personal finance manager for KDE";
    mainProgram = "kmymoney";
    homepage = "https://kmymoney.org/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      aidalgol
      das-g
    ];
  };
})
