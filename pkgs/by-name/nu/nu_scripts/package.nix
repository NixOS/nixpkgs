{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installAgentSkills,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2026-09-20";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "a571833566d71671151566e1a2cda4e6338f27bb";
    hash = "sha256-LKONPdLlXfDZ03tEHiJ7rH49vwPHaiFIE0Zvi3bh+UY=";
  };

  nativeBuildInputs = [ installAgentSkills ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
    rm -r $out/share/nu_scripts/themes/screenshots
    rm -r $out/share/nu_scripts/skills/ # installAgentSkills installs these in the correct directory

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
