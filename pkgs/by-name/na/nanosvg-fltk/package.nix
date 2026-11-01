{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nanosvg-fltk";
  version = "2022-12-22";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fltk";
    repo = "nanosvg";
    tag = "fltk_${finalAttrs.version}";
    hash = "sha256-WNdAYu66ggpSYJ8Kt57yEA4mSTv+Rvzj9Rm1q765HpY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Simple stupid SVG parser";
    homepage = "https://github.com/fltk/nanosvg";
    license = lib.licenses.zlib;
  };
})
