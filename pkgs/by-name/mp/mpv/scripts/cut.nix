{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "mpv-cut";
  version = "2.2.0-unstable-2023-11-21";

  src = fetchFromGitHub {
    owner = "familyfriendlymikey";
    repo = "mpv-cut";
    rev = "3b18f1161ffb2ff822c88cb97e099772d4b3c26d";
    hash = "sha256-c4NHJM1qeXXBz8oyGUzS9QiAzRYiNKjmArM1K0Q2Xo0=";
  };

  dontBuild = true;
  dontCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 main.lua $out/share/mpv/scripts/cut.lua
    install -Dm644 utils $out/share/mpv/scripts/cut/utils

    runHook postInstall
  '';

  passthru.scriptName = "cut.lua";

  meta = {
    description = "An mpv plugin for cutting videos incredibly quickly";
    homepage = "https://github.com/familyfriendlymikey/mpv-cut";
    license = lib.licenses.unfree; # the repository doesn't have a license
    maintainers = with lib.maintainers; [ ncfavier ];
  };
}
