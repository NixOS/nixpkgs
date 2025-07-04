{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2025-06-12";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "32cdc96414995e41de2a653719b7ae7375352eef";
    hash = "sha256-vn/YosQZ4OkWQqG4etNwISjzGJfxMucgC3wMpMdUwUg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Place to share Nushell scripts with each other";
    homepage = "https://github.com/nushell/nu_scripts";
    license = lib.licenses.mit;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.CardboardTurkey ];
  };
}
