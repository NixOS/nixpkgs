{
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook3,
  wxGTK32,
  python3,
  zlib,
  libGLU,
  libGL,
  libX11,
  SDL2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "golly";
  version = "5.0";

  src = fetchurl {
    hash = "sha256-WDXN5CgVP5uEC6lKQ1nlyybrMC56wBoJfNf1pcgwNhE=";
    url = "mirror://sourceforge/project/golly/golly/golly-${finalAttrs.version}/golly-${finalAttrs.version}-src.tar.gz";
  };

  buildInputs = [
    wxGTK32
    python3
    zlib
    libGLU
    libGL
    libX11
    SDL2
  ];

  nativeBuildInputs = [
    (python3.withPackages (ps: [
      ps.setuptools
      ps.distutils
    ]))
    wrapGAppsHook3
  ];

  # fails nondeterministically on darwin
  enableParallelBuilding = false;

  setSourceRoot = ''
    sourceRoot=$(echo */gui-wx)
  '';

  postPatch = ''
    substituteInPlace wxprefs.cpp \
      --replace-fail 'PYTHON_SHLIB' '${python3}/lib/libpython3.so'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace makefile-gtk \
      --replace-fail '-Wl,--as-needed' "" \
      --replace-fail '-lGL ' "" \
      --replace-fail '-lGLU' ""
  '';

  makeFlags = [
    "-f"
    "makefile-gtk"
    "ENABLE_SOUND=1"
    "GOLLYDIR=${placeholder "out"}/share/golly"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "CXXC=${stdenv.cc.targetPrefix}c++"
    "LD=${stdenv.cc.targetPrefix}c++"
    "WX_CONFIG=${lib.getExe' (lib.getDev wxGTK32) "wx-config"}"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp ../golly ../bgolly "$out/bin"

    mkdir -p "$out/share/doc/golly/"
    cp ../docs/*  "$out/share/doc/golly/"

    mkdir -p "$out/share/golly"
    cp -r ../{Help,Patterns,Scripts,Rules} "$out/share/golly"

    runHook postInstall
  '';

  meta = {
    description = "Cellular automata simulation program";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      raskin
      siraben
    ];
    platforms = lib.platforms.unix;
    homepage = "https://golly.sourceforge.io/";
    downloadPage = "https://sourceforge.net/projects/golly/files/golly";
  };
})
