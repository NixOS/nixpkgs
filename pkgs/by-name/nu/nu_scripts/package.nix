{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installAgentSkills,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2026-08-25";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "cee236cf46a597b43f36b56ccee5881fc0483c56";
    hash = "sha256-vW8Lz9MQwIT7WKv2ZkVTiq+398p20RszGZhIZ3I2kq8=";
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
