{
  lib,
  punes,
  fetchpatch,
  qt6Packages,
  libsForQt5,
}:

punes.overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or [ ]) ++ [
    # Fix FTBFS with Qt 6.7.1
    # Remove when version > 0.111
    (fetchpatch {
      name = "0001-punes-Fix-compatibility-with-Qt-6.7.1.patch";
      url = "https://github.com/punesemu/puNES/commit/6e51b1a6107ad3de97edd40ae4ec2d41b32d804f.patch";
      hash = "sha256-xRalKIOb1qWgqJsFLcm7uUOblEfHDYbkukmcr4/+4Qc=";
    })

    # Fix FTBFS with Qt 6.9
    # Remove when version > 0.111
    (fetchpatch {
      name = "0002-punes-Updated-code-for-Qt-6.9.0-compatibility.patch";
      url = "https://github.com/punesemu/puNES/commit/ff906e0a79eeac9a2d16783e0accf65748bb275e.patch";
      hash = "sha256-+s7AdaUBgCseQs6Mxat/cDmQ77s6K6J0fUfyihP82jM=";
    })
  ];

  # Replace Qt5 dependencies with Qt6
  nativeBuildInputs =
    lib.subtractLists [ libsForQt5.qttools libsForQt5.wrapQtAppsHook ] (
      oldAttrs.nativeBuildInputs or [ ]
    )
    ++ [
      qt6Packages.qttools
      qt6Packages.wrapQtAppsHook
    ];

  buildInputs =
    lib.subtractLists [ libsForQt5.qtbase libsForQt5.qtsvg ] (oldAttrs.buildInputs or [ ])
    ++ [
      qt6Packages.qtbase
      qt6Packages.qtsvg
    ];

  # Enable Qt6 in CMake flags
  cmakeFlags = lib.subtractLists [ "-DENABLE_QT6_LIBS=OFF" ] (oldAttrs.cmakeFlags or [ ]) ++ [
    "-DENABLE_QT6_LIBS=ON"
  ];
})
