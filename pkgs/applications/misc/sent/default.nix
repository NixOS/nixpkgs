{ stdenv, fetchurl, farbfeld, libX11, libXft, makeWrapper
, patches ? [] }:

stdenv.mkDerivation rec {
  name = "sent-1";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "0cxysz5lp25mgww73jl0mgip68x7iyvialyzdbriyaff269xxwvv";
  };

  buildInputs = [ libX11 libXft ];
  nativeBuildInputs = [ makeWrapper ];

  # unpacking doesn't create a directory
  sourceRoot = ".";

  inherit patches;

  installFlags = [ "PREFIX=$(out)" ];
  postInstall = ''
    wrapProgram "$out/bin/sent" --prefix PATH : "${farbfeld}/bin"
  '';

  meta = with stdenv.lib; {
    description = "A simple plaintext presentation tool";
    homepage = "https://tools.suckless.org/sent/";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
