{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  zlib,
}:
stdenv.mkDerivation {
  pname = "mtproxy";
  version = "1-unstable-2025-11-04";
  src = fetchFromGitHub {
    owner = "TelegramMessenger";
    repo = "MTProxy";
    rev = "cafc3380a81671579ce366d0594b9a8e450827e9";
    hash = "sha256-tY2iwNAQIL8sCUuddy9Lm/d/W1notL27HhRtOa25VsE=";
  };
  buildInputs = [
    openssl
    zlib
  ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp objs/bin/mtproto-proxy $out/bin/
    runHook postInstall
  '';
  meta = {
    description = "Simple MT-Proto proxy";
    mainProgram = "mtproto-proxy";
    homepage = "https://github.com/TelegramMessenger/MTProxy";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nix-julia ];
    platforms = [ "x86_64-linux" ];
  };
}
