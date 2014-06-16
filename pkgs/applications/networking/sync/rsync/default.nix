{ stdenv, fetchurl, perl
, enableACLs ? true, acl ? null
, enableCopyDevicesPatch ? false
}:

assert enableACLs -> acl != null;

stdenv.mkDerivation rec {
  name = "rsync-${version}";
  version = "3.1.0";

  mainSrc = fetchurl {
    url = "http://rsync.samba.org/ftp/rsync/src/rsync-${version}.tar.gz";
    sha256 = "0kirw8wglqvwi1v8bwxp373g03xg857h59j5k3mmgff9gzvj7jl1";
  };

  patchesSrc = fetchurl {
    url = "http://rsync.samba.org/ftp/rsync/rsync-patches-${version}.tar.gz";
    sha256 = "0sl8aadpjblvbb05vgais40z90yzhr09rwz0cykjdiv452gli75p";
  };

  srcs = [mainSrc] ++ stdenv.lib.optional enableCopyDevicesPatch patchesSrc;
  patches = [(fetchurl {
      url = "https://git.samba.org/?p=rsync.git;a=commitdiff_plain;h=0dedfbce2c1b851684ba658861fe9d620636c56a";
      sha256 = "0j1pqmwsqc5mh815x28izi4baki2y2r5q8k7ma1sgs4xsgjc4rk8";
      name = "CVE-2014-2855.patch";
    })]
    ++ stdenv.lib.optional enableCopyDevicesPatch "./patches/copy-devices.diff";

  buildInputs = stdenv.lib.optional enableACLs acl;
  nativeBuildInputs = [perl];

  configureFlags = "--with-nobody-group=nogroup";

  meta = {
    homepage = http://samba.anu.edu.au/rsync/;
    description = "A fast incremental file transfer utility";
    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons stdenv.lib.maintainers.emery ];
  };
}
