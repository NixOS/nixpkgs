{ stdenv, lib, fetchFromGitHub, cmake, qt5, libuchardet, pkgconfig, makeWrapper
, shntool, flac, opusTools, vorbisTools, mp3gain, lame, wavpack, vorbisgain
, gtk3
}:

stdenv.mkDerivation rec {
  name = "flacon-${version}";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    rev = "v${version}";
    sha256 = "1sw2v2w3s79lbzhkf96m8lwvag824am7rwfzzsi8bz6sa6krmj0m";
  };

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];
  buildInputs = [ qt5.qtbase qt5.qttools libuchardet ];

  postInstall = ''
    wrapProgram $out/bin/flacon \
      --suffix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --prefix PATH : "${lib.makeBinPath [ shntool flac opusTools vorbisTools
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
