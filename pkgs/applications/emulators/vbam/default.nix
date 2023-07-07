{ lib, stdenv
, cairo
, cmake
, fetchFromGitHub
, fetchpatch
, ffmpeg
, gettext
, wxGTK32
, gtk3
, libGLU, libGL
, openal
, pkg-config
, SDL2
, sfml
, zip
, zlib
}:

stdenv.mkDerivation rec {
  pname = "visualboyadvance-m";
  version = "2.1.5";
  src = fetchFromGitHub {
    owner = "visualboyadvance-m";
    repo = "visualboyadvance-m";
    rev = "v${version}";
    sha256 = "1sc3gdn7dqkipjsvlzchgd98mia9ic11169dw8v341vr9ppb1b6m";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    cairo
    ffmpeg
    gettext
    libGLU
    libGL
    openal
    SDL2
    sfml
    zip
    zlib
    wxGTK32
    gtk3
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/visualboyadvance-m/visualboyadvance-m/commit/1d7e8ae4edc53a3380dfea88329b8b8337db1c52.patch";
      sha256 = "sha256-SV1waz2JSKiM6itwkqwlE3aOZCcOl8iyBr06tyYlefo=";
    })
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE='Release'"
    "-DENABLE_FFMPEG='true'"
    "-DENABLE_LINK='true'"
    "-DSYSCONFDIR=etc"
    "-DENABLE_SDL='true'"
  ];

  meta =  with lib; {
    description = "A merge of the original Visual Boy Advance forks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ lassulus netali ];
    homepage = "https://vba-m.com/";
    platforms = lib.platforms.linux;
  };
}
