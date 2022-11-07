{ stdenv, lib, fetchFromGitHub, cmake, pkg-config
, mpg123, ffmpeg, libvorbis, libao, jansson, speex
}:
let
  vgmstreamVersion = "r1800-5942-d0d2c1181";
in
stdenv.mkDerivation rec {
  pname = "vgmstream";
  version = "unstable-2022-10-29";

  src = fetchFromGitHub {
    owner = "vgmstream";
    repo = "vgmstream";
    rev = "d0d2c1181fb7f6bb8cd464ad46332939f466ed58";
    sha256 = "006a9vjn014ypmzn2vb8di5jvsr16959zqz8x5wpzmsmq3iwnbn3";
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
