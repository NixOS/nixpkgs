{ stdenv, fetchFromGitHub, pkgconfig, glib, notmuch }:

let
  version = "9";
in
stdenv.mkDerivation {
  pname = "notmuch-addrlookup";
  inherit version;

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "notmuch-addrlookup-c";
    rev ="v${version}";
    sha256 = "1j3zdx161i1x4w0nic14ix5i8hd501rb31daf8api0k8855sx4rc";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib notmuch ];

  installPhase = "install -D notmuch-addrlookup $out/bin/notmuch-addrlookup";

  meta = with stdenv.lib; {
    description = "Address lookup tool for Notmuch in C";
    homepage = "https://github.com/aperezdc/notmuch-addrlookup-c";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
