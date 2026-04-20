{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "figtree";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "erikdkennedy";
    repo = "figtree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-owzoM0zfKYxLJCQbL1eUE0cdSLVmm+QNRUGxbsNJ37I=";
  };

  sourceRoot = "source/fonts";

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/erikdkennedy/figtree";
    description = "Simple and friendly geometric sans serif font";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mrcjkb ];
    license = lib.licenses.ofl;
  };
})
