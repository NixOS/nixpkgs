{ stdenv
, lib
, fetchzip
, wxGTK32
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "urbackup-client";
  version = "2.5.24";

  src = fetchzip {
    url = "https://hndl.urbackup.org/Client/${version}/urbackup-client-${version}.tar.gz";
    sha256 = "sha256-n0/NVClZz6ANgEdPCtdZxsEvllIl32vwDjC2nq5R8Z4=";
  };

  buildInputs = [
    wxGTK32
    zlib
    zstd
  ];

  configureFlags = [
    "--enable-embedded-cryptopp"
  ];

  meta = with lib; {
    description = "An easy to setup Open Source client/server backup system";
    longDescription = "An easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time";
    homepage = "https://www.urbackup.org/index.html";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.mgttlinger ];
  };
}
