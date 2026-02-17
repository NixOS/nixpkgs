{
  lib,
  stdenv,
  fetchurl,
  fftw,
  gtk2,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rscw";
  version = "0.1e";

  src = fetchurl {
    url = "https://www.pa3fwm.nl/software/rscw/rscw-${finalAttrs.version}.tgz";
    sha256 = "1hxwxmqc5jinr14ya1idigqigc8qhy1vimzcwy2vmwdjay2sqik2";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk2
    fftw
  ];

  installPhase = ''
    install -D -m 0755 noisycw $out/bin/noisycw
    install -D -m 0755 rs12tlmdec $out/bin/rs12tlmdec
    install -D -m 0755 rscw $out/bin/rscw
    install -D -m 0755 rscwx $out/bin/rscwx
  '';

  meta = {
    description = "Receive CW through the soundcard";
    homepage = "https://www.pa3fwm.nl/software/rscw/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ earldouglas ];
    platforms = lib.platforms.linux;
  };
})
