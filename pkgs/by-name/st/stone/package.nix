{
  stdenv,
  lib,
  fetchurl,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stone";
  version = "2.4";

  src = fetchurl {
    url = "http://www.gcd.org/sengoku/stone/stone-${finalAttrs.version}.tar.gz";
    hash = "sha256-1dwa9uxdpQPypAs98/4ZqPv5085pa49G9NU9KsjY628=";
  };

  buildInputs = [ openssl ];

  makeFlags = [ "linux-ssl" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 stone -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "TCP/IP repeater in the application layer";
    homepage = "http://www.gcd.org/sengoku/stone/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ corngood ];
    mainProgram = "stone";
  };
})
