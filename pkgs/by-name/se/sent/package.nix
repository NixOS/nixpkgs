{
  lib,
  stdenv,
  fetchurl,
  farbfeld,
  libx11,
  libxft,
  makeWrapper,
  patches ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sent";
  version = "1";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/sent-${finalAttrs.version}.tar.gz";
    sha256 = "0cxysz5lp25mgww73jl0mgip68x7iyvialyzdbriyaff269xxwvv";
  };

  buildInputs = [
    libx11
    libxft
  ];
  nativeBuildInputs = [ makeWrapper ];

  # unpacking doesn't create a directory
  sourceRoot = ".";

  inherit patches;

  installFlags = [ "PREFIX=$(out)" ];
  postInstall = ''
    wrapProgram "$out/bin/sent" --prefix PATH : "${farbfeld}/bin"
  '';

  meta = {
    description = "Simple plaintext presentation tool";
    mainProgram = "sent";
    homepage = "https://tools.suckless.org/sent/";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
