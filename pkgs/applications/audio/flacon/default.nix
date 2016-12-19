{ stdenv, lib, fetchFromGitHub, cmake, qt5, libuchardet, pkgconfig, makeWrapper
, shntool, flac, opusTools, vorbisTools, mp3gain, lame, wavpack, vorbisgain
}:

stdenv.mkDerivation rec {
  name = "flacon-${version}";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    rev = "v${version}";
    sha256 = "0hip411k3arb96rnd22ifs9shlv0xmy96hhx1jcwdk48kw8aa9rw";
  };

  buildInputs = [ cmake qt5.qtbase qt5.qttools libuchardet pkgconfig makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/flacon \
      --prefix PATH : "${lib.makeBinPath [ shntool flac opusTools vorbisTools
      mp3gain lame wavpack vorbisgain ]}"
  '';

  meta = {
    description = "Extracts audio tracks from an audio CD image to separate tracks.";
    homepage = https://flacon.github.io/;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
