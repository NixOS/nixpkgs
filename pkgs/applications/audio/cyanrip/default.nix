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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "cyanreg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lgb92sfpf4w3nj5vlj6j7931mj2q3cmcx1app9snf853jk9ahmw";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ ffmpeg libcdio libcdio-paranoia libmusicbrainz5 curl ];

  meta = with lib; {
    homepage = "https://github.com/cyanreg/cyanrip";
    description = "Bule-ish CD ripper";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.zane ];
  };
}
