{ stdenv, fetchurl, perl
, enableACLs ? true, acl ? null
, enableCopyDevicesPatch ? false
}:

assert enableACLs -> acl != null;

stdenv.mkDerivation rec {
  name = "rsync-${version}";
  version = "3.1.2";

  mainSrc = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
    sha256 = "1hm1q04hz15509f0p9bflw4d6jzfvpm1d36dxjwihk1wzakn5ypc";
  };

  patchesSrc = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/rsync-patches-${version}.tar.gz";
    sha256 = "09i3dcl37p22dp75vlnsvx7bm05ggafnrf1zwhf2kbij4ngvxvpd";
  };

  srcs = [mainSrc] ++ stdenv.lib.optional enableCopyDevicesPatch patchesSrc;
  patches = stdenv.lib.optional enableCopyDevicesPatch "./patches/copy-devices.diff";

  buildInputs = stdenv.lib.optional enableACLs acl;
  nativeBuildInputs = [perl];

  configureFlags = "--with-nobody-group=nogroup";

  meta = with stdenv.lib; {
    homepage = http://rsync.samba.org/;
    description = "A fast incremental file transfer utility";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ simons ehmry ];
  };
}
