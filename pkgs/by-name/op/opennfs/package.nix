{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opennfs";

  version = "unstable-2025-10-19";

  src = fetchFromGitHub {
    owner = "OpenNFS";
    repo = "OpenNFS";
    rev = "e78b6bbb0cab05ddc73b83f33f7d5716bbfe194a";
    hash = "sha256-pNBUzheB4uGDclolx2Y7CRv3C/8rMtT2lOyvEsZ5JGA=";
    fetchSubmodules = true;
  };

  meta = {
    description = "An attempt to recreate the classic Need for Speed Games in open source";
    homepage = "https://github.com/OpenNFS/OpenNFS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    platforms = lib.platforms.linux;
  };
})
