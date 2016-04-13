{ stdenv, fetchFromGitHub, pkgconfig, glib, notmuch }:

stdenv.mkDerivation rec {
  name = "notmuch-addrlookup-${version}";
  version = "7";

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "notmuch-addrlookup-c";
    rev ="v${version}";
    sha256 = "0mz0llf1ggl1k46brgrqj3i8qlg1ycmkc5a3a0kg8fg4s1c1m6xk";
  };


  buildInputs = [ pkgconfig glib notmuch ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp notmuch-addrlookup "$out/bin"
  '';



  meta = with stdenv.lib; {
    description = "Address lookup tool for Notmuch in C";
    homepage = https://github.com/aperezdc/notmuch-addrlookup-c;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
