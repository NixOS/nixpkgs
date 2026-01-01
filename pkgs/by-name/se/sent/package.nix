{
  lib,
  stdenv,
  fetchurl,
  farbfeld,
  libX11,
  libXft,
  makeWrapper,
  patches ? [ ],
}:

stdenv.mkDerivation rec {
  pname = "sent";
  version = "1";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/sent-${version}.tar.gz";
    sha256 = "0cxysz5lp25mgww73jl0mgip68x7iyvialyzdbriyaff269xxwvv";
  };

  buildInputs = [
    libX11
    libXft
  ];
  nativeBuildInputs = [ makeWrapper ];

  # unpacking doesn't create a directory
  sourceRoot = ".";

  inherit patches;

  installFlags = [ "PREFIX=$(out)" ];
  postInstall = ''
    wrapProgram "$out/bin/sent" --prefix PATH : "${farbfeld}/bin"
  '';

<<<<<<< HEAD
  meta = {
    description = "Simple plaintext presentation tool";
    mainProgram = "sent";
    homepage = "https://tools.suckless.org/sent/";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pSub ];
=======
  meta = with lib; {
    description = "Simple plaintext presentation tool";
    mainProgram = "sent";
    homepage = "https://tools.suckless.org/sent/";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
