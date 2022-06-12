{ stdenv, fetchgit, lib }:

stdenv.mkDerivation {
  pname = "kvmtool";
  version = "unstable-2022-04-04";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git";
    rev = "5657dd3e48b41bc6db38fa657994bc0e030fd31f";
    sha256 = "1y1j44lk9957f2dmyrscbxl4zncp4ibvvcdj6bwylb8jsvmd5fs2";
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
