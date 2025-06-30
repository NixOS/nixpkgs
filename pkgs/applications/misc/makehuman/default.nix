{
  stdenv,
  lib,
  fetchFromGitHub,
  python3,
  qtbase,
  git-lfs,
  wrapQtAppsHook,
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
  version = "1.3.0";

  source = fetchFromGitHub {
    owner = "makehumancommunity";
    repo = "makehuman";
    rev = "v${version}";
    hash = "sha256-x0v/SkwtOl1lkVi2TRuIgx2Xgz4JcWD3He7NhU44Js4=";
    name = "${pname}-source";
  };

  assets = fetchFromGitHub {
    owner = "makehumancommunity";
    repo = "makehuman-assets";
    rev = "v${version}";
    hash = "sha256-Jd2A0PAHVdFMnDLq4Mu5wsK/E6A4QpKjUyv66ix1Gbo=";
    name = "${pname}-assets-source";
  };

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
    license = with lib.licenses; [
      agpl3Plus
      cc0
    ];
    longDescription = ''
      MakeHuman is a GUI program for procedurally generating
      realistic-looking humans.
    '';
    mainProgram = "makehuman";
    maintainers = with lib.maintainers; [ elisesouche ];
    platforms = lib.platforms.all;
  };
}
