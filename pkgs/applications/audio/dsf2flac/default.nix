{ lib, stdenv, fetchFromGitHub, autoreconfHook, boost, flac, id3lib, pkg-config
, taglib, zlib }:

stdenv.mkDerivation rec {
  pname = "dsf2flac";
  version = "unstable-2018-01-02";

  src = fetchFromGitHub {
    owner = "hank";
    repo = pname;
    rev = "b0cf5aa6ddc60df9bbfeed25548e443c99f5cb16";
    sha256 = "15j5f82v7lgs0fkgyyynl82cb1rsxyr9vw3bpzra63nacbi9g8lc";
  };

  buildInputs = [ boost flac id3lib taglib zlib ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  enableParallelBuilding = true;

  preConfigure = ''
    export LIBS="$LIBS -lz"
  '';

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

  meta = with lib; {
    description = "A DSD to FLAC transcoding tool";
    homepage = "https://github.com/hank/dsf2flac";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dmrauh ];
    platforms = with platforms; linux;
  };
}
