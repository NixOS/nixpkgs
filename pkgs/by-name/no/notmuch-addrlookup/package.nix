{ lib, stdenv, fetchFromGitHub, pkg-config, glib, notmuch }:

let
  version = "10";
in
stdenv.mkDerivation {
  pname = "notmuch-addrlookup";
  inherit version;

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "notmuch-addrlookup-c";
    rev ="v${version}";
    sha256 = "sha256-Z59MAptJw95azdK0auOuUyxBrX4PtXwnRNPkhjgI6Ro=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib notmuch ];

  installPhase = "install -D notmuch-addrlookup $out/bin/notmuch-addrlookup";

  meta = with lib; {
    description = "Address lookup tool for Notmuch in C";
    homepage = "https://github.com/aperezdc/notmuch-addrlookup-c";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.unix;
    license = licenses.mit;
    mainProgram = "notmuch-addrlookup";
  };
}
