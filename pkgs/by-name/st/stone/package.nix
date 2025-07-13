{
  stdenv,
  lib,
  fetchurl,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "stone";
  version = "2.4";

  src = fetchurl {
    url = "https://www.gcd.org/sengoku/stone/stone-${version}.tar.gz";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildInputs = [ openssl ];

  makeFlags = [ "linux-ssl" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 stone -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "TCP/IP repeater in the application layer";
    homepage = "http://www.gcd.org/sengoku/stone/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ corngood ];
    mainProgram = "stone";
  };
}
