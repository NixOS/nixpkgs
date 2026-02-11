{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lcdf-typetools";
  version = "2.110";

  src = fetchFromGitHub {
    owner = "kohler";
    repo = "lcdf-typetools";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-hoILYYCef2R1v6aN9V+FoYnXYaKsnGN2jlpb/QFAN/w=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--without-kpathsea" ];

  meta = {
    description = "Utilities for manipulating OpenType, PostScript Type 1, and Multiple Master fonts";
    homepage = "https://www.lcdf.org/type";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
})
