{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  pname = "sunwait";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "risacher";
    repo = "sunwait";
    rev = finalAttrs.version;
    hash = "sha256-v2cNjecJ4SstOsvDe/Lu0oOyBd8I8LMHZIH+f9ZC7Fc=";
  };

  makeFlags = [ "C=${stdenv.cc.targetPrefix}c++" ];

  installPhase = ''
    install -Dm755 sunwait -t $out/bin
  '';

  meta = {
    description = "Calculates sunrise or sunset times with civil, nautical, astronomical and custom twilights";
    homepage = "https://github.com/risacher/sunwait";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "sunwait";
    platforms = lib.platforms.all;
  };
})
