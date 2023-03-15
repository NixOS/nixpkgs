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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "cyanreg";
    repo = pname;
    rev = "v${version}";
    sha256 = "17bi2xhjv3f3i870whkyqckvjlg32wqkspash87zi0jw7m7jm229";
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
