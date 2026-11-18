{
  lib,
  stdenv,
  fetchFromGitHub,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meslo-lgs-nf";
  version = "2.3.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k-media";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8xwVOlOP1SresbReNh1ce2Eu12KdIwdJSg6LKM+k2ng=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Meslo Nerd Font patched for Powerlevel10k";
    homepage = "https://github.com/romkatv/powerlevel10k-media";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bbigras ];
    platforms = lib.platforms.all;
  };
})
