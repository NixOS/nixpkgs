{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obd-drift-monitor";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Nickdom1";
    repo = "obd-drift-monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1BKXwmPFb1DSYm81/d70kP4hatyCPNEJKPkcK2ZBpOo=";
  };

  # The decoder is a Cargo workspace living in a subdirectory of the project repo.
  sourceRoot = "${finalAttrs.src.name}/pkgs/decode-rs";

  cargoHash = "sha256-XVuhSIUQymWbqjwcOvQN5TcWBB3DluyFNEtRGC1JZSg=";

  meta = {
    description = "Monitor OBD-II self-diagnostic sensor readings over time to reveal drift";
    longDescription = ''
      OBD Drift Monitor turns the results of a vehicle's built-in self-diagnostics
      (OBD-II Mode 06 on-board monitor tests, plus Mode 01 live PIDs) into a time
      series, so a sensor slowly drifting toward its pass/fail limits over weeks or
      months becomes visible as a trend long before it trips a fault code. It
      answers "how has this sensor changed over the last six months?" rather than
      only "how is the car doing right now?" that a snapshot scan tool provides.

      Readings are captured at the CAN-bus level and turned into structured,
      limit-scaled values by decoderd, the project's small native decode engine
      (JSON lines in, decoded monitor/PID values out) — the executable this
      package provides and the same one deployed in the monitor's pipeline.
    '';
    homepage = "https://github.com/Nickdom1/obd-drift-monitor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickdom1 ];
    mainProgram = "decoderd";
    platforms = lib.platforms.all;
  };
})
