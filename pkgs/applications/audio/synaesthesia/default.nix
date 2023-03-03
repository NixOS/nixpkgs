{ stdenv
, lib
, fetchzip
, SDL
, pkg-config
, libSM
}:
stdenv.mkDerivation rec {
  pname = "synaesthesia";
  version = "2.4";

  src = fetchzip {
    url = "https://logarithmic.net/pfh-files/synaesthesia/synaesthesia-${version}.tar.gz";
    sha256 = "0nzsdxbah0shm2vlziaaw3ilzlizd3d35rridkpg40nfxmq84qnx";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    SDL
    libSM
  ];

  meta = {
    homepage = "https://logarithmic.net/pfh/synaesthesia";
    description = "Program for representing sounds visually";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.infinisil ];
  };
}
