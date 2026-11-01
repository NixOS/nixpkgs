{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple stupid SVG parser";
    homepage = "https://github.com/fltk/nanosvg";
    license = lib.licenses.zlib;
  };
})
