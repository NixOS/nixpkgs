{ stdenv, lib, fetchFromGitHub, cmake, libuchardet, pkg-config, shntool, flac
, opusTools, vorbis-tools, mp3gain, lame, taglib, wavpack, vorbisgain, gtk3, qtbase
, qttools, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "flacon";
<<<<<<< HEAD
  version = "11.2.0";
=======
  version = "10.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-pDTBA9HpFzwagz9B5AmaHzML361ON3XA+OIZJQyAuJo=";
=======
    sha256 = "sha256-59p5x+d7Vmxx+bdBDxrlf4+NRIdUBuRk+DqohV98XYY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [ qtbase qttools libuchardet taglib ];

  bin_path = lib.makeBinPath [
    shntool
    flac
    opusTools
    vorbis-tools
    mp3gain
    lame
    wavpack
    vorbisgain
  ];

  postInstall = ''
    wrapProgram $out/bin/flacon \
      --suffix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --prefix PATH : "$bin_path";
  '';

  meta = with lib; {
    description =
      "Extracts audio tracks from an audio CD image to separate tracks";
    homepage = "https://flacon.github.io/";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ snglth ];
  };
}
