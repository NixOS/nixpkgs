{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  eigen,
  pkg-config,
}:

stdenv.mkDerivation (final: {
  pname = "poselib";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "PoseLib";
    repo = "PoseLib";
    rev = "v${final.version}";
    hash = "sha256-fARRKT2UoPuuk9FOOsBdrACwGiGXWg/mLV4R0QIjeak=";
  };

  buildInputs = [ eigen ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "A collection of minimal solvers for camera pose estimation";
    homepage = "https://github.com/PoseLib/PoseLib";
    changelog = "https://github.com/PoseLib/PoseLib/releases/tag/v${final.version}";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ usertam ];
  };
})
