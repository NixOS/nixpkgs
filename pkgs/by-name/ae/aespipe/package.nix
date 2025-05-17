{
  lib,
  stdenv,
  fetchurl,
  sharutils,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "aespipe";
  version = "2.4i";

  src = fetchurl {
    url = "mirror://sourceforge/loop-aes/aespipe/aespipe-v${version}.tar.bz2";
    sha256 = "sha256-tBx6qsJULlnY/1jB/52HtS1KjBhHt5nIr+yR2UUXx14=";
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

  meta = with lib; {
    description = "AES encrypting or decrypting pipe";
    homepage = "https://loop-aes.sourceforge.net/aespipe.README";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
