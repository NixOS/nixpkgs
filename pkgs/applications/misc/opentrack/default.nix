{ mkDerivation, lib, callPackage, fetchzip, fetchFromGitHub, cmake, pkg-config
, ninja, copyDesktopItems, qtbase, qttools, opencv4, procps, eigen, libXdmcp
, libevdev, makeDesktopItem, fetchurl }:

let
  version = "2.3.13";

  aruco = callPackage ./aruco.nix { };

  # license.txt inside the zip file is MIT
  xplaneSdk = fetchzip {
    url = "https://developer.x-plane.com/wp-content/plugins/code-sample-generation/sample_templates/XPSDK303.zip";
    sha256 = "11wqjsr996c5qhiv2djsd55gc373a9qcq30dvc6rhzm0fys42zba";
  };

in mkDerivation {
  pname = "opentrack";
  inherit version;

  src = fetchFromGitHub {
    owner = "opentrack";
    repo = "opentrack";
    rev = "opentrack-${version}";
    sha256 = "1s986lmm5l1pwbwvd1pfiq84n32s1q1dav7a0cbga4d1vcf0v1ay";
  };

  nativeBuildInputs = [ cmake pkg-config ninja copyDesktopItems ];
  buildInputs = [ qtbase qttools opencv4 procps eigen libXdmcp libevdev aruco ];

  NIX_CFLAGS_COMPILE = "-Wall -Wextra -Wpedantic -ffast-math -march=native -O3";

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=RELEASE"
    "-DSDK_ARUCO_LIBPATH=${aruco}/lib/libaruco.a"
    "-DSDK_XPLANE=${xplaneSdk}"
  ];

  desktopItems = [
    (makeDesktopItem rec {
      name = "opentrack";
      exec = "opentrack";
      icon = fetchurl {
        url = "https://github.com/opentrack/opentrack/raw/opentrack-${version}/gui/images/opentrack.png";
        sha256 = "0d114zk78f7nnrk89mz4gqn7yk3k71riikdn29w6sx99h57f6kgn";
      };
      desktopName = name;
      genericName = "Head tracking software";
      categories = [ "Utility" ];
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/opentrack/opentrack";
    description = "Head tracking software for MS Windows, Linux, and Apple OSX";
    license = licenses.isc;
    maintainers = with maintainers; [ zaninime ];
  };
}
