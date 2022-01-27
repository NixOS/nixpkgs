{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, ffmpeg
, libcdio
, libcdio-paranoia
, libmusicbrainz5
, curl
}:
stdenv.mkDerivation rec {
  pname = "cyanrip";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "cyanreg";
    repo = pname;
    rev = "v${version}";
    sha256 = "1aip52bwkq8cb1d8ifyv2m6m5dz7jk6qmbhyb97yyf4nhxv445ky";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ ffmpeg libcdio libcdio-paranoia libmusicbrainz5 curl ];

  meta = with lib; {
    homepage = "https://github.com/cyanreg/cyanrip";
    description = "Bule-ish CD ripper";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.zane ];
  };
}
