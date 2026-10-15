{
  lib,
  stdenv,
  fetchFromGitHub,
  libevent,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redsocks";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "darkk";
    repo = "redsocks";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-ld4NewksfSS3zT1WZOdLur28Sr83Saz5FN6sHfe+DJw=";
  };

  installPhase = ''
    mkdir -p $out/{bin,share}
    mv redsocks $out/bin
    mv doc $out/share
  '';

  buildInputs = [ libevent ];

  meta = {
    description = "Transparent redirector of any TCP connection to proxy";
    homepage = "https://darkk.net.ru/redsocks/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "redsocks";
  };
})
