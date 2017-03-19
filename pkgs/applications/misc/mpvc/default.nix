{ stdenv, socat, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  name = "mpvc-unstable-2017-03-18";

  src = fetchFromGitHub {
    owner = "wildefyr";
    repo = "mpvc";
    rev = "aea5c661455248cde7ac9ddba5f63cc790d26512";
    sha256 = "0qiyvb3ck1wyd3izajwvlq4bwgsbq7x8ya3fgi5i0g2qr39a1qml";
  };

  installPhase = ''
    make PREFIX=$out install
  '';

  # defaults to make install.
  buildPhase = ''
    make PREFIX=$out
  '';

  postInstall = ''
    makeWrapper ${socat}/bin/socat $out/bin/socat \
      --prefix PATH : "$out/bin"
    wrapProgram $out/bin/mpvc
  '';

  buildInputs = [ socat makeWrapper ];
  outputs = [ "out" ];

  meta = {
    description = "A mpc-like control interface for mpv";
    homepage = https://github.com/wildefyr/mpvc;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
