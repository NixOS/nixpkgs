{ stdenv
, lib
, cmake
, fetchFromGitHub
, wrapQtAppsHook
, qtbase
, qtquickcontrols2
, qtgraphicaleffects
}:

stdenv.mkDerivation rec {
  pname = "graphia";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "graphia-app";
    repo = "graphia";
    rev = version;
    sha256 = "sha256-9JIVMtu8wlux7vIapOQQIemE7ehIol2XZuIvwLfB8fY=";
  };

  patches = [
    # Fix for a breakpad incompatibility with glibc>2.33
    # https://github.com/pytorch/pytorch/issues/70297
    # https://github.com/google/breakpad/commit/605c51ed96ad44b34c457bbca320e74e194c317e
    ./breakpad-sigstksz.patch
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
