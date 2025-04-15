{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "0-unstable-2025-04-07";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "b7869a8f337dc64f4d1dbf8f2c7a5833bc3abfbf";
    hash = "sha256-IoyClULiILl5wPwyf7zzTK5Rb0yEbkVpFRtUSHksrjc=";
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
    license = lib.licenses.free;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.CardboardTurkey ];
  };
}
