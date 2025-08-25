{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bully";
  version = "1.4-00";

  src = fetchFromGitHub {
    owner = "kimocoder";
    repo = "bully";
    tag = finalAttrs.version;
    hash = "sha256-zr4pKmIoMitknvrvuv23nBacYmVDQqBIII+QXxQpR9g=";
  };

  buildInputs = [ libpcap ];

  enableParallelBuilding = true;

  sourceRoot = "source/src";

  installPhase = ''
    install -Dm555 -t $out/bin bully
    install -Dm444 -t $out/share/doc/bully ../*.md
  '';

  meta = {
    description = "Retrieve WPA/WPA2 passphrase from a WPS enabled access point";
    homepage = "https://github.com/kimocoder/bully";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ edwtjo ];
    platforms = lib.platforms.linux;
    mainProgram = "bully";
  };
})
