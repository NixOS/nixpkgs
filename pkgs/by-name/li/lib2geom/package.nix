{
  stdenv,
  fetchFromGitLab,
  cmake,
  ninja,
  pkg-config,
  boost,
  glib,
  gsl,
  cairo,
  double-conversion,
  gtest,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "lib2geom";
  version = "1.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    owner = "inkscape";
    repo = "lib2geom";
    rev = "refs/tags/${version}";
    hash = "sha256-kbcnefzNhUj/ZKZaB9r19bpI68vxUKOLVAwUXSr/zz0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    glib
    gsl
    cairo
    double-conversion
  ];

  nativeCheckInputs = [
    gtest
  ];

  cmakeFlags = [
    "-D2GEOM_BUILD_SHARED=ON"
  ];

  doCheck = true;

  # TODO: Update cmake hook to make it simpler to selectively disable cmake tests: #113829
  checkPhase =
    let
      disabledTests =
        lib.optionals stdenv.hostPlatform.isAarch64 [
          # Broken on all platforms, test just accidentally passes on some.
          # https://gitlab.com/inkscape/lib2geom/-/issues/63
          "elliptical-arc-test"
        ]
        ++ lib.optionals stdenv.hostPlatform.isMusl [
          # Fails due to rounding differences
          # https://gitlab.com/inkscape/lib2geom/-/issues/70
          "circle-test"
        ]
        ++ lib.optionals (stdenv.hostPlatform.system != "x86_64-linux") [
          # https://gitlab.com/inkscape/lib2geom/-/issues/69
          "polynomial-test"

          # https://gitlab.com/inkscape/lib2geom/-/issues/75
          "line-test"

          # Failure observed on aarch64-darwin
          "bezier-test"
          "ellipse-test"
        ];
    in
    ''
      runHook preCheck
      ctest --output-on-failure -E '^${lib.concatStringsSep "|" disabledTests}$'
      runHook postCheck
    '';

  meta = with lib; {
    description = "Easy to use 2D geometry library in C++";
    homepage = "https://gitlab.com/inkscape/lib2geom";
    license = [
      licenses.lgpl21Only
      licenses.mpl11
    ];
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
