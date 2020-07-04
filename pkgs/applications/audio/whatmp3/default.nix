{ stdenv, fetchFromGitHub, flac, lame, vorbis-tools, vorbisgain, mktorrent, makeWrapper, python3, mp3gain, aacgain, sox }:

stdenv.mkDerivation rec {
  pname = "whatmp3";
  version = "3.8";
  src = fetchFromGitHub {
    rev = "v3.8";
    owner = "RecursiveForest";
    repo = "whatmp3";
    sha256 = "0vqczxdk90sdld0yxgc1kknlyszmb4ys1bhr53n39nbhgwssh1df";
  };

  buildInputs = [ python3 ];
  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace config.mk --replace /usr/local $out
  '';

  postInstall = ''
    wrapProgram $out/bin/whatmp3 \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [
        flac
        lame
        vorbis-tools
        vorbisgain
        mktorrent
        mp3gain
        aacgain
        sox
      ]}"
  '';

  meta = with stdenv.lib; {
    description = "whatmp3 transcodes audio files and creates torrents for them";
    homepage = "https://github.com/RecursiveForest/whatmp3";
    license = licenses.mit;
    maintainers = with maintainers; [ dominikh ];
    platforms = platforms.all;
  };
}
