{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "yapesdl";
  version = "0.70.2";

  src = fetchFromGitHub {
    owner = "calmopyrin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-51P6wNaSfVA3twu+yRUKXguEmVBvuuEnHxH1Zl1vsCc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    SDL2
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}c++" ];

  installPhase = ''
    runHook preInstall
    install --directory $out/bin $out/share/doc/$pname
    install yapesdl $out/bin/
    install README.SDL $out/share/doc/$pname/
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://yape.plus4.net/";
    description = "Multiplatform Commodore 64 and 264 family emulator";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
