{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  file,
  libpng,
  libjpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "farbfeld";
  version = "4";

  src = fetchurl {
    url = "https://dl.suckless.org/farbfeld/farbfeld-${finalAttrs.version}.tar.gz";
    sha256 = "0ap7rcngffhdd57jw9j22arzkbrhwh0zpxhwbdfwl8fixlhmkpy7";
  };

  buildInputs = [
    libpng
    libjpeg
  ];
  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];
  postInstall = ''
    wrapProgram "$out/bin/2ff" --prefix PATH : "${file}/bin"
  '';

  meta = {
    description = "Suckless image format with conversion tools";
    homepage = "https://tools.suckless.org/farbfeld/";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
