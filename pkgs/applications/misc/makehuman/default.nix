{ stdenv
, lib
, fetchpatch
, fetchFromGitHub
, python3
, qtbase
, git-lfs
, wrapQtAppsHook
}:

let
  pydeps = with python3.pkgs; [
    numpy
    pyqt5
    pyopengl
  ];
  python = python3.withPackages (pkgs: pydeps);
in
stdenv.mkDerivation rec {
  pname = "makehuman";
  version = "1.2.0";

  source = fetchFromGitHub {
    owner = "makehumancommunity";
    repo = "makehuman";
    rev = "v${version}";
    hash = "sha256-mCv6H0B7b4uxozpNHkKsG+Is2H0QYEJnnzKCHixhBpY=";
    name = "${pname}-source";
  };

  assets = fetchFromGitHub {
    owner = "makehumancommunity";
    repo = "makehuman-assets";
    rev = "v${version}";
    hash = "sha256-Jd2A0PAHVdFMnDLq4Mu5wsK/E6A4QpKjUyv66ix1Gbo=";
    name = "${pname}-assets-source";
  };

  patches = [
    # work with numpy>=1.24
    (fetchpatch {
      name = "fix-compile_targets.py-when-using-numpy-1.24.0-or-newer";
      url = "https://patch-diff.githubusercontent.com/raw/makehumancommunity/makehuman/pull/220.patch";
      hash = "sha256-ip7U83cCBrl+4gM1GZ2QQIER5Qur6HRu3a/TnHqk//g=";
    })
    # crash related to collections.Callable -> collections.abc.Callable
    (fetchpatch {
      name = "remove-unnecessary-compatibility-test";
      url = "https://patch-diff.githubusercontent.com/raw/makehumancommunity/makehuman/pull/188.patch";
      hash = "sha256-HGrk3n7rhV4YgK8mNUdfHwQl8dFT8yuzjxorvwfMmJw=";
    })
    # some OpenGL issue causing blank windows on recent Qt
    (fetchpatch {
      name = "qt-opengl-update-from-qglwidget-to-qopenglwidget-to-fix-blank";
      url = "https://patch-diff.githubusercontent.com/raw/makehumancommunity/makehuman/pull/197.patch";
      hash = "sha256-fEqBwg1Jd36nKWIT9XPr6Buj1N3AmTQg2LBaoX3eTxw=";
    })
    # multisampling issue
    (fetchpatch {
      name = "switch-default-for-multisampling-and-disable-sample-buffers";
      url = "https://github.com/makehumancommunity/makehuman/commit/c47b884028a24eb190d097e7523a3059e439cb6f.patch";
      hash = "sha256-tknQHX9qQYH15gyOLNhxfO3bsFVIv3Z1F7ZXD1IT1h4=";
    })
    # PyQt >= 5.12
    (fetchpatch {
      name = "fix-scrolling-issue-on-pyqt5>=5.12";
      url = "https://github.com/makehumancommunity/makehuman/commit/02c4269a2d4c57f68159fe8f437a8b1978b99099.patch";
      hash = "sha256-yR5tZcELX0N83PW/vS6yB5xKoZcHhVp48invlu7quWM=";
    })
  ];

  srcs = [
    source
    assets
  ];

  sourceRoot = ".";

  nativeBuildInputs = [
    python
    qtbase
    git-lfs
    wrapQtAppsHook
  ];

  buildInputs = [
    python
    qtbase
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pydeps
  ];

  finalSource = "${pname}-final";

  postUnpack = ''
    mkdir -p $finalSource
    cp -r $source/makehuman $finalSource
    chmod u+w $finalSource --recursive
    cp -r $assets/base/* $finalSource/makehuman/data
    chmod u+w $finalSource --recursive
    sourceRoot=$finalSource
  '';

  configurePhase = ''
    runHook preConfigure
    pushd ./makehuman
    bash ./cleannpz.sh
    bash ./cleanpyc.sh
    python3 ./compile_targets.py
    python3 ./compile_models.py
    python3 ./compile_proxies.py
    popd
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/opt $out/bin
    cp -r * $out/opt
    python -m compileall -o 0 -o 2 $out/opt
    ln -s $out/opt/makehuman/makehuman.py $out/bin/makehuman
    chmod +x $out/bin/makehuman
    runHook postBuild
  '';

  preFixup = ''
    wrapQtApp $out/bin/makehuman
  '';

  meta = {
    description = "Software to create realistic humans";
    homepage = "http://www.makehumancommunity.org/";
    license = with lib.licenses; [ agpl3Plus cc0 ];
    longDescription = ''
      MakeHuman is a GUI program for procedurally generating
      realistic-looking humans.
    '';
    mainProgram = "makehuman";
    maintainers = with lib.maintainers; [ elisesouche ];
    platforms = lib.platforms.all;
  };
}
