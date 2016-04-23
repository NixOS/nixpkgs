{ stdenv, fetchurl, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "xtrabackup-${version}";
  version = "2.3.4";

  src = fetchurl {
    url = "https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.3.4/source/tarball/percona-xtrabackup-${version}.tar.gz";
    md5 = "89f2a8196c79b00b4f4ed3b609891bfd";
  };

  buildInputs = with pkgs; [
     bison
     cmake
     curl
     libaio
     libev
     libgcrypt
     libgpgerror
     ncurses
     percona
     vim
     xxdiff
     ];

  enableParallelBuilding = true;
  cmakeFlags = [
    "-DBUILD_CONFIG=xtrabackup_release"
    "-DGCRYPT_LIB_PATH=${pkgs.libgcrypt}/lib:${pkgs.libgpgerror}/lib"
    "-DWITH_MAN_PAGES=OFF"
  ];

  meta = {
    homepage = https://www.percona.com/;
    description = "Percona XtraBackup";
  };
}
