{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "autoenv";
  version = "0-unstable-2024-10-16";

  src = fetchFromGitHub {
    owner = "hyperupcall";
    repo = "autoenv";
    rev = "90241f182d6a7c96e9de8a25c1eccaf2a2d1b43a";
    hash = "sha256-vZrsMPhuu+xPVAww04nKyoOl7k0upvpIaxeMrCikDio=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -R $src $out/share/autoenv
    chmod +x $out/share/autoenv
    runHook postInstall
  '';

  meta = {
    description = "Per-directory shell environments sourced from .env file";
    homepage = "https://github.com/hyperupcall/autoenv";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ clebs ];
  };
})
