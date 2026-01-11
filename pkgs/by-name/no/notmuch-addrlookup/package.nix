{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  notmuch,
}:

let
  version = "10";
in
stdenv.mkDerivation {
  pname = "notmuch-addrlookup";
  inherit version;

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "notmuch-addrlookup-c";
    rev = "v${version}";
    sha256 = "sha256-Z59MAptJw95azdK0auOuUyxBrX4PtXwnRNPkhjgI6Ro=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    notmuch
  ];

  installPhase = "install -D notmuch-addrlookup $out/bin/notmuch-addrlookup";

  meta = {
    description = "Address lookup tool for Notmuch in C";
    homepage = "https://github.com/aperezdc/notmuch-addrlookup-c";
    maintainers = with lib.maintainers; [ mog ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    mainProgram = "notmuch-addrlookup";
  };
}
