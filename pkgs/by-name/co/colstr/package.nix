{
  lib,
  stdenv,
  fetchFromGitea,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "colstr";
  version = "1.0.0";

  src = fetchFromGitea {
    domain = "git.sleeping.town";
    owner = "wonder";
    repo = "colstr";
    rev = finalAttrs.version;
    hash = "sha256-0V2S/yYu5L7qxkT4Zf18x9+cHoPMztFmgSywpxF8QqA=";
  };

  buildPhase = ''
    runHook preBuild

    eval ${stdenv.cc.targetPrefix}c++ main.cpp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 a.out $out/bin/colstr

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Deterministically output each input argument in a color assigned to it";
    homepage = "https://git.sleeping.town/wonder/colstr";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ annaaurora ];
    mainProgram = "colstr";
    platforms = platforms.all;
  };
})
