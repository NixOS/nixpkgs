{ stdenv
, lib
, fetchzip
, wxGTK32
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "urbackup-client";
  version = "2.5.25";

  src = fetchzip {
    url = "https://hndl.urbackup.org/Client/${version}/urbackup-client-${version}.tar.gz";
    sha256 = "sha256-+xm2mBcTLMvrstCq2sLgJiU3zbFCassKvln3SMmRH9s=";
  };

  postPatch = ''
    find | fgrep crc.cpp
    # Fix gcc-13 build failures due to missing includes
    sed -e '1i #include <cstdint>' -i \
      blockalign_src/crc.cpp
  '';

  buildInputs = [
    wxGTK32
    zlib
    zstd
  ];

  configureFlags = [
    "--enable-embedded-cryptopp"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Easy to setup Open Source client/server backup system";
    longDescription = "An easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time";
    homepage = "https://www.urbackup.org/index.html";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.mgttlinger ];
  };
}
