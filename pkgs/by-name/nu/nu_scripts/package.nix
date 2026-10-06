{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installAgentSkills,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2026-10-02";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "3ffc5aa43194bb4d5295dec9fbf0a18b3a2dddfc";
    hash = "sha256-/6nbTNfpkNRUJcXnQKw9yrm3UAvgfUoyKbNRUkQAfPY=";
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
