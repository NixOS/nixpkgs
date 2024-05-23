{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "protonhax";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "jcnils";
    repo = "protonhax";
    rev = finalAttrs.version;
    hash = "sha256-5G4MCWuaF/adSc9kpW/4oDWFFRpviTKMXYAuT2sFf9w=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 protonhax -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Run programs inside your game proton's environment.";
    homepage = "https://github.com/jcnils/protonhax";
    license = lib.licenses.bsd3;
    mainProgram = "protonhax";
    maintainers = with lib.maintainers; [ quantenzitrone ];
    platform = lib.platforms.linux;
  };
})
