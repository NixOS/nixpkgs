{ lib
, stdenv
, fetchFromGitHub
, cmake
, qt5
, ffmpeg-full
, aria2
, yt-dlp
, python3
}:

stdenv.mkDerivation rec {
  pname = "media-downloader";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-2hc/p+rwlM1p+odM6vl5gDOc2wgvpRVqAgod13dNd0I=";
  };

  nativeBuildInputs = [ cmake qt5.wrapQtAppsHook ];

  preFixup = ''
    qtWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ffmpeg-full aria2 yt-dlp python3 ]}"
    )
  '';

  meta = with lib; {
    description = "A Qt/C++ GUI front end to youtube-dl";
    homepage = "https://github.com/mhogomchungu/media-downloader";
    license = licenses.gpl2Plus;
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
}
