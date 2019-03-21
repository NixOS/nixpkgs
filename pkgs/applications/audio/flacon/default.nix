{ stdenv, lib, fetchFromGitHub, cmake, qt5, libuchardet, pkgconfig, makeWrapper
, shntool, flac, opusTools, vorbis-tools, mp3gain, lame, wavpack, vorbisgain
, gtk3
}:

stdenv.mkDerivation rec {
  name = "flacon-${version}";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    rev = "v${version}";
    sha256 = "18m077z1hqjg10chy5rgajd9q1wnrcxhiidivgjcdchc9q5d4b08";
  };

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];
  buildInputs = [ qt5.qtbase qt5.qttools libuchardet ];

  postInstall = ''
    wrapProgram $out/bin/flacon \
      --suffix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --prefix PATH : "${lib.makeBinPath [ shntool flac opusTools vorbis-tools
     mp3gain lame wavpack vorbisgain ]}"
  '';

  meta = with stdenv.lib; {
    description = "Extracts audio tracks from an audio CD image to separate tracks.";
    homepage = https://flacon.github.io/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ndowens nico202 ];
  };
}
