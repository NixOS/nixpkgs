{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, qtbase
, aria2
, ffmpeg
, python3
, yt-dlp
}:

stdenv.mkDerivation rec {
  pname = "media-downloader";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = pname;
    rev = version;
    hash = "sha256-+wLVF0UKspVll+dYZGSk5dUbPBc/2Y0cqTuaeepxw+k=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [
        aria2
        ffmpeg
        python3
        yt-dlp
      ]}"
  ];

  meta = with lib; {
    description = "A Qt/C++ GUI front end to youtube-dl";
    homepage = "https://github.com/mhogomchungu/media-downloader";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
