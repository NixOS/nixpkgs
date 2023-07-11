{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, ffmpeg-headless
, libcdio
, libcdio-paranoia
, libmusicbrainz5
, curl
}:
stdenv.mkDerivation rec {
  pname = "cyanrip";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "cyanreg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gH/rWTRYX10Q2Y9oSaMu0bOy3SMbcSNmH3dkXHFAw90";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ ffmpeg-headless libcdio libcdio-paranoia libmusicbrainz5 curl ];

  meta = with lib; {
    homepage = "https://github.com/cyanreg/cyanrip";
    description = "Bule-ish CD ripper";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.zane ];
  };
}
