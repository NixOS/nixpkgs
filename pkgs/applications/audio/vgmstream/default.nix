{ stdenv, lib, fetchFromGitHub, cmake, pkg-config
, mpg123, ffmpeg, libvorbis, libao, jansson
}:
stdenv.mkDerivation rec {
  pname   = "vgmstream";
  version = "r1050-3448-g77cc431b";

  src = fetchFromGitHub {
    owner  = "vgmstream";
    repo   = "vgmstream";
    rev    = version;
    sha256 = "030q02c9li14by7vm00gn6v3m4dxxmfwiy9iyz3xsgzq1i7pqc1d";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ mpg123 ffmpeg libvorbis libao jansson ];

  # There's no nice way to build the audacious plugin without a circular dependency
  cmakeFlags = [ "-DBUILD_AUDACIOUS=OFF" ];

  preConfigure = ''
    echo "#define VERSION \"${version}\"" > cli/version.h
  '';

  meta = with lib; {
    description = "A library for playback of various streamed audio formats used in video games";
    homepage    = "https://vgmstream.org";
    maintainers = with maintainers; [ zane ];
    license     = with licenses; isc;
    platforms   = with platforms; unix;
  };
}
