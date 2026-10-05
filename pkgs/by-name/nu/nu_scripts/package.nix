{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installAgentSkills,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2026-07-19";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "381eb7577705b00bea437da7c0439c39ff05f06b";
    hash = "sha256-b4/JOcpUa2BittwZz/w3IPUik4QPlpqcgc2dgDDbb1E=";
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
