{
  fetchFromGitHub,
  lib,
  stdenv,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dotconf";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "williamh";
    repo = "dotconf";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6Du26Ffz08DLGg6uIiPi8Sgjf691MM2kn0qXe3oFeTw=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Configuration parser library";
    maintainers = with lib.maintainers; [ pSub ];
    homepage = "https://github.com/williamh/dotconf";
    license = lib.licenses.lgpl21Plus;
    platforms = with lib.platforms; unix;
  };
})
