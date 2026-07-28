{
  lib,
  stdenv,
  fetchsvn,
  pkg-config,
  which,
  autoconf,
  automake,
  libtool,
  hexdump,
  libao,
  zlib,
  curl,
}:

stdenv.mkDerivation {
  pname = "sc68";
  version = "2.2.1-unstable-2024-09-09";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/sc68/code/";
    rev = "713";
    sha256 = "sha256-kiOHUixsf/2mFMzi6P7oC7ujyydLO7K3w7Vwr/GMOvY=";
  };

  postPatch = ''
    substituteInPlace vcversion.sh \
      --replace-fail 'date -u "+%Y%m%d"' 'date -u --date=@$SOURCE_DATE_EPOCH "+%Y%m%d"'
  '';

  preConfigure = ''
    tools/svn-bootstrap.sh
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoconf
    automake
    hexdump
    libtool
    pkg-config
    which
  ];

  buildInputs = [
    curl
    libao
    zlib
  ];

  # Doesn't specify any standard target, but it's >20yo code
  env.CFLAGS = "-std=c99";

  meta = {
    description = "Atari ST and Amiga music player";
    homepage = "http://sc68.atari.org/project.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
}
