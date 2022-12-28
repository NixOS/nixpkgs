{ stdenv, fetchgit, lib }:

stdenv.mkDerivation {
  pname = "kvmtool";
  version = "unstable-2022-06-09";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git";
    rev = "f44af23e3a62e46158341807b0d2d132249b96a8";
    sha256 = "sha256-M83dCCXU/fkh21x10vx6BLg9Wja1714qW7yxl5zY6z0=";
  };

  enableParallelBuilding = true;
  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    description = "A lightweight tool for hosting KVM guests";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/tree/README";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ astro ];
    platforms = [ "x86_64-linux" ];
  };
}
