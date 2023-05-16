<<<<<<< HEAD
{ aria2
, cmake
, fetchFromGitHub
, ffmpeg
, lib
, python3
, qtbase
, stdenv
, wrapQtAppsHook
, yt-dlp
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "media-downloader";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = "media-downloader";
    rev = finalAttrs.version;
    hash = "sha256-UmNaosunkNUTm4rsf4q29H+0cJAccUDx+ulcS2octIo=";
=======
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
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = pname;
    rev = "${version}";
    hash = "sha256-/oKvjmLFchR2B/mcLIUVIHBK78u2OQGf2aiwVR/ZoQc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  meta = {
    description = "A Qt/C++ GUI front end to youtube-dl";
    homepage = "https://github.com/mhogomchungu/media-downloader";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ zendo ];
    platforms = lib.platforms.linux;
  };
})
=======
  meta = with lib; {
    description = "A Qt/C++ GUI front end to youtube-dl";
    homepage = "https://github.com/mhogomchungu/media-downloader";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
