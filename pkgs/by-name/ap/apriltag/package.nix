{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3Packages,
  nix-update-script,
}:

let
  opencv4WithGtk = python3Packages.opencv4.override {
    enableGtk2 = true; # For GTK2 support
    enableGtk3 = true; # For GTK3 support
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "apriltags";
  version = "3.4.5";

  src = fetchFromGitHub {
    owner = "AprilRobotics";
    repo = "AprilTags";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pBUjRKfP884+bNgV5B4b8TiuhyZ9p/jIluxs+idv/28=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ opencv4WithGtk ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_EXAMPLES" true) ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visual fiducial system popular for robotics research";
    homepage = "https://april.eecs.umich.edu/software/apriltag";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
