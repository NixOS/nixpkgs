{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  autoreconfHook,
  wxwidgets_3_2,
  boost186,
  lua5_5,
  zlib,
  bzip2,
  xylib,
  readline,
  gnuplot,
  swig,
}:
let
  lua = lua5_5;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "fityk";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "wojdyr";
    repo = "fityk";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-m2RaZMYT6JGwa3sOUVsBIzCdZetTbiygaInQWoJ4m1o=";
  };

  patches = [
    # Accept Lua 5.5 in configure (https://github.com/wojdyr/fityk/pull/64).
    # Can be dropped at the next release.
    (fetchpatch2 {
      name = "fityk-detect-lua-5.5.patch";
      url = "https://github.com/wojdyr/fityk/commit/48456231ca58211d7bcde0d2d8ac0c29cae2ab16.patch?full_index=1";
      hash = "sha256-QkhNnGRuSP0bGqK7GtHfx2OpkEZoz8YI7M2m4f5N1Pw=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    lua
    swig
  ];
  buildInputs = [
    wxwidgets_3_2
    boost186
    lua
    zlib
    bzip2
    xylib
    readline
    gnuplot
  ];

  configureFlags = [
    "--with-wx-config=${lib.getExe' (lib.getDev wxwidgets_3_2) "wx-config"}"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-std=c++11"
  ];

  meta = {
    description = "Curve fitting and peak fitting software";
    license = lib.licenses.gpl2;
    homepage = "https://fityk.nieto.pl/";
    platforms = lib.platforms.linux;
  };
})
