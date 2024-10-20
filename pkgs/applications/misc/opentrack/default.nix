{
  mkDerivation,
  lib,
  callPackage,
  fetchzip,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  copyDesktopItems,
  qtbase,
  qttools,
  opencv4,
  procps,
  eigen,
  libXdmcp,
  libevdev,
  makeDesktopItem,
  fetchurl,
}: let
  version = "2023.3.0";

  aruco = callPackage ./aruco.nix {};

  # license.txt inside the zip file is MIT
  xplaneSdk = fetchzip {
    url = "https://developer.x-plane.com/wp-content/plugins/code-sample-generation/sdk_zip_files/XPSDK401.zip";
    hash = "sha256-tUT9yV1949QVr5VebU/7esg7wwWkyak2TSA/kQSrbeo=";
  };
in
  mkDerivation {
    pname = "opentrack";
    inherit version;

    src = fetchFromGitHub {
      owner = "opentrack";
      repo = "opentrack";
      rev = "opentrack-${version}";
      sha256 = "sha256-C0jLS55DcLJh/e5yM8kLG7fhhKvBNllv5HkfCWRIfc4=";
    };

    patches = [
      # https://github.com/opentrack/opentrack/pull/1754
      ./0001-fix-wine-no-wrapper.patch
    ];

    nativeBuildInputs = [cmake pkg-config ninja copyDesktopItems];
    buildInputs = [qtbase qttools opencv4 procps eigen libXdmcp libevdev aruco];

    env.NIX_CFLAGS_COMPILE = "-Wall -Wextra -Wpedantic -ffast-math -O3";
    dontWrapQtApps = true;

    cmakeFlags = [
      "-DSDK_ARUCO_LIBPATH=${aruco}/lib/libaruco.a"
      "-DSDK_XPLANE=${xplaneSdk}"
    ];

    postInstall = ''
      wrapQtApp $out/bin/opentrack
    '';

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
        categories = ["Utility"];
      })
    ];

    meta = with lib; {
      homepage = "https://github.com/opentrack/opentrack";
      description = "Head tracking software for MS Windows, Linux, and Apple OSX";
      mainProgram = "opentrack";
      changelog = "https://github.com/opentrack/opentrack/releases/tag/${version}";
      license = licenses.isc;
      maintainers = with maintainers; [zaninime];
    };
  }
