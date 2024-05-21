{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  pkg-config,
  SDL2,
  libpng,
  ffmpeg,
  freetype,
  glew,
  libGL,
  libGLU,
  fribidi,
  zlib,
  harfbuzz,
  makeWrapper,
}:

let
  # https://renpy.org/doc/html/changelog.html#versioning
  # base_version is of the form major.minor.patch
  # vc_version is of the form YYMMDDCC
  # version corresponds to the tag on GitHub
  base_version = "8.2.1";
  vc_version = "24030407";
  version = "${base_version}.${vc_version}";
in
stdenv.mkDerivation {
  pname = "renpy";
  inherit version;

  src = fetchFromGitHub {
    owner = "renpy";
    repo = "renpy";
    rev = version;
    hash = "sha256-07Hj8mJGR0+Pn1DQ+sK5YQ3x3CTMsZ5h5yEoz44b2TM=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    # Ren'Py currently does not compile on Cython 3.x.
    # See https://github.com/renpy/renpy/issues/5359
    python3.pkgs.cython_0
    python3.pkgs.setuptools
  ];

  buildInputs =
    [
      SDL2
      libpng
      ffmpeg
      freetype
      glew
      libGLU
      libGL
      fribidi
      zlib
      harfbuzz
    ]
    ++ (with python3.pkgs; [
      python
      pygame-sdl2
      tkinter
      future
      six
      pefile
      requests
      ecdsa
    ]);

  RENPY_DEPS_INSTALL = lib.concatStringsSep "::" [
    SDL2
    SDL2.dev
    libpng
    ffmpeg.lib
    freetype
    glew.dev
    libGLU
    libGL
    fribidi
    zlib
    harfbuzz.dev
  ];

  enableParallelBuilding = true;

  patches = [ ./shutup-erofs-errors.patch ];

  postPatch = ''
    cp tutorial/game/tutorial_director.rpy{m,}

    cat > renpy/vc_version.py << EOF
    version = '${version}'
    official = False
    nightly = False
    # Look at https://renpy.org/latest.html for what to put.
    version_name = '64bit Sensation'
    EOF
  '';

  buildPhase = with python3.pkgs; ''
    runHook preBuild
    ${python.pythonOnBuildForHost.interpreter} module/setup.py build --parallel=$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = with python3.pkgs; ''
    runHook preInstall

    ${python.pythonOnBuildForHost.interpreter} module/setup.py install_lib -d $out/${python.sitePackages}
    mkdir -p $out/share/renpy
    cp -vr sdk-fonts gui launcher renpy the_question tutorial renpy.py $out/share/renpy

    makeWrapper ${python.interpreter} $out/bin/renpy \
      --set PYTHONPATH "$PYTHONPATH:$out/${python.sitePackages}" \
      --add-flags "$out/share/renpy/renpy.py"

    runHook postInstall
  '';

  env.NIX_CFLAGS_COMPILE = with python3.pkgs; "-I${pygame-sdl2}/include/${python.libPrefix}";

  meta = {
    description = "Visual Novel Engine";
    mainProgram = "renpy";
    homepage = "https://renpy.org/";
    changelog = "https://renpy.org/doc/html/changelog.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ shadowrz ];
  };

  passthru = {
    inherit base_version vc_version;
  };
}
