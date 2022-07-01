{ stdenv, lib, fetchzip, wxGTK30, zlib, zstd }:

stdenv.mkDerivation rec {
  pname = "urbackup-client";
  version = "2.4.11";

  src = fetchzip {
    url = "https://hndl.urbackup.org/Client/${version}/urbackup-client-${version}.tar.gz";
    sha256 = "0cciy9v1pxj9qaklpbhp2d5rdbkmfm74vhpqx6b4phww0f10wvzh";
  };

  configureFlags = [ "--enable-embedded-cryptopp" ];
  buildInputs = [ wxGTK30 zlib zstd ];

  meta = with lib; {
    description = "An easy to setup Open Source client/server backup system";
    longDescription = "An easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time";
    homepage = "https://www.urbackup.org/index.html";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.mgttlinger ];
  };
}
