{ stdenv, lib, fetchFromGitHub, cmake, qt5, libuchardet, pkgconfig, makeWrapper
, shntool, flac, opusTools, vorbisTools, mp3gain, lame, wavpack, vorbisgain
, gtk3
}:

stdenv.mkDerivation rec {
  name = "flacon-${version}";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    rev = "v${version}";
    sha256 = "0jazv3d1xaydp2ws1pd5rmga76z5yk74v3a8yqfc8vbb2z6ahimz";
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
