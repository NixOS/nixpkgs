{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtwebengine
, gitUpdater
}:

<<<<<<< HEAD
let
  pname = "gitqlient";
  version = "1.5.0";

  main_src = fetchFromGitHub {
    owner = "francescmm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mq29HbmPABrRIJjWC5AAKIOKbGngeJdkZkWeJw8BFuw=";
  };
  aux_src = fetchFromGitHub rec {
    owner = "francescmm";
    repo = "AuxiliarCustomWidgets";
    rev = "835f538b4a79e4d6bb70eef37a32103e7b2a1fd1";
    sha256 = "sha256-b1gb/7UcLS6lI92dBfTenGXA064t4dZufs3S9lu/lQA=";
    name = repo;
  };
  qlogger_src = fetchFromGitHub rec {
    owner = "francescmm";
    repo = "QLogger";
    rev = "d1ed24e080521a239d5d5e2c2347fe211f0f3e4f";
    sha256 = "sha256-NVlFYmm7IIkf8LhQrAYXil9kH6DFq1XjOEHQiIWmER4=";
    name = repo;
  };
  qpinnabletab_src = fetchFromGitHub rec {
    owner = "francescmm";
    repo = "QPinnableTabWidget";
    rev = "cc937794e910d0452f0c07b4961c6014a7358831";
    sha256 = "sha256-2KzzBv/s2t665axeBxWrn8aCMQQArQLlUBOAlVhU+wE=";
    name = repo;
  };
  git_src = fetchFromGitHub rec {
    owner = "francescmm";
    repo = "git";
    rev = "b62750f4da4b133faff49e6f53950d659b18c948";
    sha256 = "sha256-4FqA+kkHd0TqD6ZuB4CbJ+IhOtQG9uWN+qhSAT0dXGs=";
    name = repo;
  };
in

mkDerivation rec {
  inherit pname version;

  srcs = [ main_src aux_src qlogger_src qpinnabletab_src git_src ];

  sourceRoot = main_src.name;
=======
mkDerivation rec {
  pname = "gitqlient";
  version = "1.5.0";

  srcs = [
    (fetchFromGitHub {
      owner = "francescmm";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-Mq29HbmPABrRIJjWC5AAKIOKbGngeJdkZkWeJw8BFuw=";
    })
    (fetchFromGitHub rec {
      owner = "francescmm";
      repo = "AuxiliarCustomWidgets";
      rev = "835f538b4a79e4d6bb70eef37a32103e7b2a1fd1";
      sha256 = "sha256-b1gb/7UcLS6lI92dBfTenGXA064t4dZufs3S9lu/lQA=";
      name = repo;
    })
    (fetchFromGitHub rec {
      owner = "francescmm";
      repo = "QLogger";
      rev = "d1ed24e080521a239d5d5e2c2347fe211f0f3e4f";
      sha256 = "sha256-NVlFYmm7IIkf8LhQrAYXil9kH6DFq1XjOEHQiIWmER4=";
      name = repo;
    })
    (fetchFromGitHub rec {
      owner = "francescmm";
      repo = "QPinnableTabWidget";
      rev = "cc937794e910d0452f0c07b4961c6014a7358831";
      sha256 = "sha256-2KzzBv/s2t665axeBxWrn8aCMQQArQLlUBOAlVhU+wE=";
      name = repo;
    })
    (fetchFromGitHub rec {
      owner = "francescmm";
      repo = "git";
      rev = "b62750f4da4b133faff49e6f53950d659b18c948";
      sha256 = "sha256-4FqA+kkHd0TqD6ZuB4CbJ+IhOtQG9uWN+qhSAT0dXGs=";
      name = repo;
    })
  ];

  sourceRoot = "source";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtwebengine
  ];

  postUnpack = ''
    for dep in AuxiliarCustomWidgets QPinnableTabWidget QLogger git; do
<<<<<<< HEAD
      rmdir "${main_src.name}/src/$dep"
      ln -sf "../../$dep" "${main_src.name}/src/$dep"
=======
      rmdir "source/src/$dep"
      ln -sf "../../$dep" "source/src/$dep"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    done
  '';

  qmakeFlags = [
    "GitQlient.pro"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://github.com/francescmm/GitQlient";
    description = "Multi-platform Git client written with Qt";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
