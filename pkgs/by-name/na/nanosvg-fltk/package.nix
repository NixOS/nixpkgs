{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation {
  pname = "nanosvg-fltk";
  version = "unstable-2022-12-22";

  src = fetchFromGitHub {
    owner = "fltk";
    repo = "nanosvg";
    rev = "abcd277ea45e9098bed752cf9c6875b533c0892f";
    hash = "sha256-WNdAYu66ggpSYJ8Kt57yEA4mSTv+Rvzj9Rm1q765HpY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Simple stupid SVG parser";
    homepage = "https://github.com/fltk/nanosvg";
    license = lib.licenses.zlib;
  };
}
