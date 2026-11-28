{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  python3,
  git-lfs,
  libsForQt5,
}:

let
  pydeps = with python3.pkgs; [
    numpy
    pyqt5
    pyopengl
  ];
  python = python3.withPackages (pkgs: pydeps);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "makehuman";
  version = "1.3.0";

  source = fetchFromGitHub {
    owner = "makehumancommunity";
    repo = "makehuman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x0v/SkwtOl1lkVi2TRuIgx2Xgz4JcWD3He7NhU44Js4=";
    name = "makehuman-source";
  };

  assets = fetchFromGitHub {
    owner = "makehumancommunity";
    repo = "makehuman-assets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jd2A0PAHVdFMnDLq4Mu5wsK/E6A4QpKjUyv66ix1Gbo=";
    name = "makehuman-assets-source";
  };

  srcs = with finalAttrs; [
    source
    assets
  ];

  sourceRoot = ".";

  nativeBuildInputs = [
    python
    libsForQt5.qtbase
    git-lfs
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    python
    libsForQt5.qtbase
  ];

  propagatedBuildInputs = pydeps;

  finalSource = "makehuman-final";

  postUnpack = ''
    mkdir -p $finalSource
    cp -r $source/makehuman $finalSource
    chmod u+w $finalSource --recursive
    cp -r $assets/base/* $finalSource/makehuman/data
    chmod u+w $finalSource --recursive
    sourceRoot=$finalSource
  '';

  patches = [
    # https://github.com/makehumancommunity/makehuman/pull/271 (closed unmerged)
    ./replace-deprecated-tostring.patch
    # Remove use of the imp module, which was removed in Python 3.12
    (fetchpatch2 {
      url = "https://github.com/makehumancommunity/makehuman/commit/4dbb64b82cd618cfb45cbb2d06c6f25627e922fe.patch?full_index=1";
      hash = "sha256-bSRsVHY3UjQ1T+WSvIdP7MzrepmjCCZ0cHayTB8HOeE=";
    })
    (fetchpatch2 {
      url = "https://github.com/makehumancommunity/makehuman/commit/fca763c4360f7c16597f23b8d5f552586a82c32a.patch?full_index=1";
      hash = "sha256-GeFpHg0OD7fNDmJZVIiBMjjBRt16b6jbezYUqwXbMvY=";
    })
    # Drop the encoding argument of json.loads, which was removed in Python 3.9
    (fetchpatch2 {
      url = "https://github.com/makehumancommunity/makehuman/commit/4f37318b1f052cb54fd88a129d65f044986ed751.patch?full_index=1";
      hash = "sha256-R3kSW6zU26sxPRC0rwXayk1KLe1x1VY2HsQvSGHRt7c=";
    })
  ];

  # ndarray.tostring was removed in NumPy 2 and is not fully covered by the
  # upstream pull request
  postPatch = ''
    substituteInPlace \
      makehuman/makehuman.py \
      makehuman/shared/proxy.py \
      makehuman/lib/image.py \
      makehuman/lib/image_qt.py \
      --replace-fail '.tostring()' '.tobytes()'

    # NumPy 2 raises when copy=False cannot avoid a copy; copy=None restores
    # the NumPy 1 behaviour of copying only when needed
    substituteInPlace makehuman/core/transformations.py \
      --replace-fail 'copy=False' 'copy=None'

    # numpy.trapz was removed in NumPy 2.4
    substituteInPlace makehuman/shared/image_operations.py \
      --replace-fail 'numpy.trapz(' 'numpy.trapezoid('
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
})
