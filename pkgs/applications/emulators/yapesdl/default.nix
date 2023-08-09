{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, SDL2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yapesdl";
  version = "0.71.2";

  src = fetchFromGitHub {
    owner = "calmopyrin";
    repo = "yapesdl";
    rev = "v${finalAttrs.version}";
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
    install -Dm755 yapesdl -t $out/bin/
    install -Dm755 README.SDL -t $out/share/doc/yapesdl/
    runHook postInstall
  '';

  meta = {
    homepage = "http://yape.plus4.net/";
    description = "Multiplatform Commodore 64 and 264 family emulator";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
