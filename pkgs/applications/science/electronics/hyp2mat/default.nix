{ stdenv
, fetchFromGitHub
, bison
, flex
, gengetopt
, help2man
, groff
, libharu
, autoreconfHook
, pkgconfig
, libpng
, zlib
}:

stdenv.mkDerivation rec {
  pname = "hyp2mat";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "koendv";
    repo = "hyp2mat";
    rev = "v${version}";
    sha256 = "04bd2vrn8y1izir7pwl34a60cg2v05baqcrmpfdx5fvf33bbflaj";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    libharu
    libpng
    zlib
    bison
    flex
    gengetopt
    help2man
    groff
  ];

  configureFlags = [ "--enable-library" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Import Hyperlynx Boardsim files to openEMS, an open source 3D full-wave electromagnetic field solver";
    homepage = https://github.com/koendv/hyp2mat;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
