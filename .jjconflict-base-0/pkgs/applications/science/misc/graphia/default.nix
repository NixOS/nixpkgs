{ stdenv
, lib
, cmake
, git
, fetchFromGitHub
, fetchpatch
, wrapQtAppsHook
, qtbase
, qtdeclarative
, qtsvg
, qtwebengine
}:

stdenv.mkDerivation rec {
  pname = "graphia";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "graphia-app";
    repo = "graphia";
    rev = version;
    sha256 = "sha256-8+tlQbTr6BGx+/gjviuNrQQWcxC/j6dJ+PxwB4fYmqQ=";
  };

  patches = [
    # Fix gcc-13 build:
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/graphia-app/graphia/commit/78fb55a4d73f96e9a182de433c7da60330bd5b5e.patch";
      hash = "sha256-waI2ur3gOKMQvqB2Qnyz7oMOMConl3jLMVKKmOmTpJs=";
    })
  ];

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

  meta = with lib; {
    # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/graphia.x86_64-darwin
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin;
    description = "Visualisation tool for the creation and analysis of graphs";
    homepage = "https://graphia.app";
    license = licenses.gpl3Only;
    mainProgram = "Graphia";
    maintainers = [ maintainers.bgamari ];
    platforms = platforms.all;
  };
}
