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
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "PoseLib";
    repo = "PoseLib";
    rev = "v${final.version}";
    hash = "sha256-5cd0k53kqggJCzz3ajPcUeBIi5KuvBUG7SQKsHBWIdU=";
  };

  buildInputs = [ eigen ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  enableParallelBuilding = true;
  enableParallelInstalling = true;

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
