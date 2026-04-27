{
  lib,
  stdenv,
  fetchFromGitHub,
  symlinkJoin,
  cosmic-ext-alternative-startup,
  cosmic-ext-sway-daemon,
  cosmic-session,
  dbus,
  nix-update-script,
}:
let
  version = "0-unstable-2025-04-02";

  src = fetchFromGitHub {
    owner = "Drakulix";
    repo = "cosmic-ext-extra-sessions";
    rev = "66e065728d81eab86171e542dad08fb628c88494";
    hash = "sha256-6JiWdBry63NrnmK3mt9gGSDAcyx/f6L5QsIgZSUakQI=";
  };

  makeSession =
    {
      compositorName ? lib.toSentenceCase name,
      name,
    }:
    let
      pname = "cosmic-ext-${name}";
      desktopFile = "${pname}.desktop";
      sessionCommand = "start-${pname}";
    in
    stdenv.mkDerivation {
      inherit pname src version;

      postPatch = ''
        substituteInPlace ${name}/${desktopFile} \
          --replace-fail "/usr/${
            lib.optionalString (name == "niri") "local/"
          }bin/${sessionCommand}" "${placeholder "out"}/bin/${sessionCommand}"

        substituteInPlace ${name}/${sessionCommand} \
          --replace-fail '/usr/bin/dbus-run-session' '${lib.getExe' dbus "dbus-run-session"}' \
          --replace-fail "/usr/bin/cosmic-session" "${lib.getExe cosmic-session}"

        ${lib.optionalString (name == "sway") ''
            substituteInPlace ${name}/${sessionCommand} \
              --replace-fail "/etc/sway/config-cosmic" "${placeholder "out"}/etc/sway/config-cosmic"

          substituteInPlace ${name}/config-cosmic \
            --replace-fail "/usr/bin/cosmic-ext-alternative-startup" "${lib.getExe cosmic-ext-alternative-startup}" \
            --replace-fail "/usr/bin/cosmic-ext-sway-daemon" "${lib.getExe cosmic-ext-sway-daemon}"
        ''}
      '';

      installPhase = ''
        runHook preInstall

        install -Dm644 ${name}/${desktopFile} $out/share/wayland-sessions/${desktopFile}
        install -Dm755 ${name}/${sessionCommand} $out/bin/${sessionCommand}

        ${lib.optionalString (name == "sway") ''
          install -Dm644 ${name}/config-cosmic $out/etc/sway/config-cosmic
        ''}

        runHook postInstall
      '';

      passthru.providedSessions = [ "cosmic-ext-${name}" ];

      meta = {
        description = "Unofficial ${compositorName} alternative session for COSMIC Desktop";
        homepage = "https://github.com/Drakulix/cosmic-ext-extra-sessions";
        license = lib.licenses.gpl3Only;
        mainProgram = sessionCommand;
        maintainers = [ lib.maintainers.HeitorAugustoLN ];
        platforms = lib.platforms.linux;
      };
    };

  sessions = {
    miracle = makeSession { name = "miracle"; };
    niri = makeSession { name = "niri"; };
    sway = makeSession { name = "sway"; };
  };
in
symlinkJoin {
  pname = "cosmic-ext-extra-sessions";
  inherit version;

  paths = builtins.attrValues sessions;

  passthru = sessions // {
    inherit makeSession;

    providedSessions = lib.pipe sessions [
      (lib.mapAttrsToList (_: pkg: pkg.passthru.providedSessions))
      lib.flatten
    ];

    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };
  };

  meta = {
    description = "Unofficial alternative sessions for COSMIC Desktop";
    homepage = "https://github.com/Drakulix/cosmic-ext-extra-sessions";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
}
