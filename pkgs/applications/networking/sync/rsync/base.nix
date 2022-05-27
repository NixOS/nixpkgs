{ lib, fetchurl, fetchpatch }:

rec {
  version = "3.2.4";
  src = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
    sha256 = "sha256-b3YYONCAUrC2V5z39nN9k+R/AfTaBMXSTTRHt/Kl+tE=";
  };
  upstreamPatchTarball = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/rsync-patches-${version}.tar.gz";
    sha256 = "sha256-cKWXWQr2xhzz0F1mNCn/n2D/4k5E+cc6TNxp69wTIqQ=";
  };

  meta = with lib; {
    description = "Fast incremental file transfer utility";
    homepage = "https://rsync.samba.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
