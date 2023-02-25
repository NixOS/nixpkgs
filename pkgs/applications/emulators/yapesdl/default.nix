{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "yapesdl";
  version = "0.71.2";

  src = fetchFromGitHub {
    owner = "calmopyrin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QGF3aS/YSzdGxHONKyA/iTewEVYsjBAsKARVMXkFV2k=";
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
