{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libzen, libmediainfo, zlib }:

stdenv.mkDerivation rec {
  pname = "mediainfo";
<<<<<<< HEAD
  version = "23.07";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    hash = "sha256-ttfanimZX9NKIhAIJbhD50wyx7xnrbARZrG+7epJ9dA=";
=======
  version = "23.04";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    sha256 = "sha256-Uiut1rHk6LV+giW6e0nvgn35ffTLaLbU/HkQ92xf32k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libzen libmediainfo zlib ];

<<<<<<< HEAD
  sourceRoot = "MediaInfo/Project/GNU/CLI";
=======
  sourceRoot = "./MediaInfo/Project/GNU/CLI/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  configureFlags = [ "--with-libmediainfo=${libmediainfo}" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Supplies technical and tag information about a video or audio file";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = "https://mediaarea.net/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
<<<<<<< HEAD
    mainProgram = "mediainfo";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
