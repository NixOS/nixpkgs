{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lebiniou-data";
  version = "3.67.0";

  src = fetchFromGitLab {
    owner = "lebiniou";
    repo = "lebiniou-data";
    tag = "version-${finalAttrs.version}";
    hash = "sha256-ZReih+axmTcahkPEzmSPdONiGQKh3KrF6GRLNoXv/M0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Images, colormaps, sequences and web interface for Le Biniou";
    homepage = "https://biniou.lenain.info/";
    license = with lib.licenses; [
      gpl2Plus
      cc0
      cc-by-40
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ FlorianFranzen ];
    platforms = lib.platforms.all;
  };
})
