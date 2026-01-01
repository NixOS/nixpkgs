{
  stdenv,
  lib,
  cmake,
  git,
  fetchFromGitHub,
  wrapQtAppsHook,
  qtbase,
  qtdeclarative,
  qtsvg,
  qtwebengine,
}:

stdenv.mkDerivation rec {
  pname = "graphia";
  version = "5.2";

  src = fetchFromGitHub {
    owner = "graphia-app";
    repo = "graphia";
    rev = version;
    sha256 = "sha256-tS5oqpwpqvWGu67s8OuA4uQR3Zb5VzHTY/GnfVQki6k=";
  };

  nativeBuildInputs = [
    cmake
    git # needs to define some hash as a version
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    qtwebengine
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/graphia.x86_64-darwin
    broken =
      (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin;
    description = "Visualisation tool for the creation and analysis of graphs";
    homepage = "https://graphia.app";
<<<<<<< HEAD
    license = lib.licenses.gpl3Only;
    mainProgram = "Graphia";
    maintainers = [ lib.maintainers.bgamari ];
    platforms = lib.platforms.all;
=======
    license = licenses.gpl3Only;
    mainProgram = "Graphia";
    maintainers = [ maintainers.bgamari ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
