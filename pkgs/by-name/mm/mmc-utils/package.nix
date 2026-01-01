{
  lib,
  stdenv,
  fetchgit,
  gitUpdater,
  sparse,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mmc-utils";
  version = "1.0";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iWLA1psNPUBCPOP393/xnYJ6BEuOcPCEYgymqE06F3Q=";
  };

  nativeBuildInputs = [ sparse ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "prefix=$(out)"
    "mandir=$(out)/share/man"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

<<<<<<< HEAD
  meta = {
    description = "Configure MMC storage devices from userspace";
    mainProgram = "mmc";
    homepage = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.dezgeg ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Configure MMC storage devices from userspace";
    mainProgram = "mmc";
    homepage = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
