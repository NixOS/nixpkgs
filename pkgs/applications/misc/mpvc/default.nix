{ lib, stdenv, socat, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation {
  pname = "mpvc";
  version = "unstable-2017-03-18";

  src = fetchFromGitHub {
    owner = "wildefyr";
    repo = "mpvc";
    rev = "aea5c661455248cde7ac9ddba5f63cc790d26512";
    sha256 = "0qiyvb3ck1wyd3izajwvlq4bwgsbq7x8ya3fgi5i0g2qr39a1qml";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/mpvc --prefix PATH : "${socat}/bin/"
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ socat ];

  meta = with lib; {
    description = "A mpc-like control interface for mpv";
    homepage = "https://github.com/wildefyr/mpvc";
    license = licenses.mit;
    maintainers = [ maintainers.neeasade ];
    platforms = platforms.linux;
  };
}
