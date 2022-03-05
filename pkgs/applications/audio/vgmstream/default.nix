{ stdenv, lib, fetchFromGitHub, cmake, pkg-config
, mpg123, ffmpeg, libvorbis, libao, jansson, speex
}:
let
  vgmstreamVersion = "r1702-5596-00bdb165b";
in
stdenv.mkDerivation rec {
  pname = "vgmstream";
  version = "unstable-2022-02-21";

  src = fetchFromGitHub {
    owner = "vgmstream";
    repo = "vgmstream";
    rev = "00bdb165ba6b55420bbd5b21f54c4f7a825d15a0";
    sha256 = "18g1yqlnf48hi2xn2z2wajnjljpdbfdqmcmi7y8hi1r964ypmfcr";
  };

  passthru.updateScript = ./update.sh;

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ mpg123 ffmpeg libvorbis libao jansson speex ];

  cmakeFlags = [
    # There's no nice way to build the audacious plugin without a circular dependency
    "-DBUILD_AUDACIOUS=OFF"
    # It always tries to download it, no option to use the system one
    "-DUSE_CELT=OFF"
  ];

  postConfigure = ''
    echo "#define VGMSTREAM_VERSION \"${vgmstreamVersion}\"" > ../version.h
  '';

  meta = with lib; {
    description = "A library for playback of various streamed audio formats used in video games";
    homepage    = "https://vgmstream.org";
    maintainers = with maintainers; [ zane ];
    license     = with licenses; isc;
    platforms   = with platforms; unix;
  };
}
