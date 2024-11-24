{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbalpha2012";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbalpha2012";
    rev = "77167cea72e808384c136c8c163a6b4975ce7a84";
    hash = "sha256-giEV09dT/e82bmDlRkxpkW04JcsEZc/enIPecqYtg3c=";
  };

  makefile = "makefile.libretro";
  preBuild = "cd svn-current/trunk";

  meta = {
    description = "Port of Final Burn Alpha ~2012 to libretro";
    homepage = "https://github.com/libretro/fbalpha2012";
    license = lib.licenses.unfreeRedistributable;
  };
}
