{ stdenv
, lib
, cmake
, fetchFromGitHub
, fetchpatch
, wrapQtAppsHook
, qtbase
, qtquickcontrols2
, qtgraphicaleffects
}:

stdenv.mkDerivation rec {
  pname = "graphia";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "graphia-app";
    repo = "graphia";
    rev = version;
    sha256 = "sha256-9kohXLXF4F/qoHm8qmvPM1y9ak0Thb4xvgKJlVuOPTg=";
  };

  patches = [
    # Fix for a breakpad incompatibility with glibc>2.33
    # https://github.com/pytorch/pytorch/issues/70297
    # https://github.com/google/breakpad/commit/605c51ed96ad44b34c457bbca320e74e194c317e
    ./breakpad-sigstksz.patch

    # FIXME: backport patch fixing build with Qt 5.15, remove for next release
    (fetchpatch {
      url = "https://github.com/graphia-app/graphia/commit/4b51bb8d465afa7ed0b2b30cb1c5e1c6af95976f.patch";
      hash = "sha256-GDJAFLxQlRWKvcOgqqPYV/aVTRM7+KDjW7Zp9l7SuyM=";
    })
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtquickcontrols2
    qtgraphicaleffects
  ];

  meta = with lib; {
    # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/graphia.x86_64-darwin
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "A visualisation tool for the creation and analysis of graphs.";
    homepage = "https://graphia.app";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.bgamari ];
    platforms = platforms.all;
  };
}
