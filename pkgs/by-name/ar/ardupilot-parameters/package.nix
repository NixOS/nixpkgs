{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ardupilot-parameters";
  version = "0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "ArduPilot";
    repo = "ParameterRepository";
    rev = "124fd7ea863c34a82ac529cca6d641951097c73a";
    hash = "sha256-PfOj0DGdKMq6X5a56AoiloBa/1ZppQJQKeiiIf7kKI0=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/ardupilot-parameters
    cp -r --no-preserve=mode -t $out/share/ardupilot-parameters -- */

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Per-version ArduPilot vehicle parameter metadata (apm.pdef.json), consumed by QGroundControl's APM firmware plugin for offline parameter editing";
    homepage = "https://github.com/ArduPilot/ParameterRepository";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
  };
})
