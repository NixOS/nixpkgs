{
  lib,
  stdenv,
  fetchurl,
  ocamlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hevea";
  version = "2.38";

  src = fetchurl {
    url = "https://hevea.inria.fr/distri/hevea-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-ciA4BlAHIm8Po95GKRJylNLim/u8QQQsg6Vw+gxFWkc=";
  };

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    ocamlbuild
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Quite complete and fast LATEX to HTML translator";
    homepage = "https://hevea.inria.fr/";
    changelog = "https://github.com/maranget/hevea/raw/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.qpl;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = with lib.platforms; unix;
  };
})
