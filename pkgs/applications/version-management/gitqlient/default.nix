{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtwebengine
, gitUpdater
}:

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

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtwebengine
  ];

  postUnpack = ''
    for dep in AuxiliarCustomWidgets QPinnableTabWidget QLogger git; do
      rmdir "source/src/$dep"
      ln -sf "../../$dep" "source/src/$dep"
    done
  '';

  qmakeFlags = [
    "GitQlient.pro"
  ];

  passthru.updateScript = gitUpdater {
    inherit pname version;
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
