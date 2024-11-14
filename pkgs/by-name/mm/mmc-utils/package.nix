{ lib, stdenv, fetchzip, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "mmc-utils";
  version = "unstable-2024-03-07";

  src = fetchzip rec {
    url = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/snapshot/mmc-utils-${passthru.rev}.tar.gz";
    passthru.rev = "e1281d4de9166b7254ba30bb58f9191fc2c9e7fb";
    sha256 = "/lkcZ/ArdBAStV9usavrbfjULXenqb+h2rbDJzxZjJk=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "prefix=$(out)" ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    cp man/mmc.1 $out/share/man/man1/
  '';

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater {
    url = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git";
  };

  meta = with lib; {
    description = "Configure MMC storage devices from userspace";
    mainProgram = "mmc";
    homepage = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
