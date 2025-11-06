{
  lib,
  stdenv,
  fetchurl,
  sharutils,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "aespipe";
  version = "2.4j";

  src = fetchurl {
    url = "mirror://sourceforge/loop-aes/aespipe/aespipe-v${version}.tar.bz2";
    sha256 = "sha256-RI/h5YYSwYSVFkXd2Sb8W9tk/E8vgox2bIKqESfpo+I=";
  };

  nativeBuildInputs = [ makeWrapper ];

  configureFlags = [
    "--enable-padlock"
    "--enable-intelaes"
  ];

  postInstall = ''
    cp bz2aespipe $out/bin
    wrapProgram $out/bin/bz2aespipe \
     --prefix PATH : $out/bin:${lib.makeBinPath [ sharutils ]}
  '';

  meta = {
    description = "AES encrypting or decrypting pipe";
    homepage = "https://loop-aes.sourceforge.net/aespipe.README";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
