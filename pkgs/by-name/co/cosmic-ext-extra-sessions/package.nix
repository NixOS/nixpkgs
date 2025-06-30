{
  lib,
  stdenv,
  rustPlatform,
  symlinkJoin,
  fetchFromGitHub,
  fetchpatch,
  just,
  dbus,
  cosmic-session,
  cosmic-ext-alternative-startup,
  nix-update-script,
}:
let
  src = fetchFromGitHub {
    owner = "drakulix";
    repo = "cosmic-ext-extra-sessions";
    rev = "66e065728d81eab86171e542dad08fb628c88494";
    hash = "sha256-6JiWdBry63NrnmK3mt9gGSDAcyx/f6L5QsIgZSUakQI=";
  };

  version = "0-unstable-2025-04-02";

  makeSession =
    {
      compositorName ? name,
      name,
    }:
    stdenv.mkDerivation {
      pname = "cosmic-ext-${name}";
      inherit src version;

      # TODO: Remove after this gets merged
      patches = [
        (fetchpatch {
          name = "modular-justfile.patch";
          url = "https://github.com/Drakulix/cosmic-ext-extra-sessions/pull/11.diff?full_index=1";
          hash = "sha256-sZIePdRLPixPZ/2DgNjWNVBRlp0L4VtNqCLSaBW1vRo=";
        })
      ];

      postPatch = ''
        substituteInPlace ${name}/cosmic-ext-${name}.desktop \
          --replace-fail "/usr/local/bin/start-cosmic-ext-${name}" "''${!outputBin}/bin/start-cosmic-ext-${name}"
        substituteInPlace ${name}/start-cosmic-ext-${name} \
          --replace-fail '/usr/bin/dbus-run-session' '${lib.getExe' dbus "dbus-run-session"}' \
          --replace-fail '/usr/bin/cosmic-session' '${lib.getExe cosmic-session}'
      '';

      nativeBuildInputs = [ just ];
      propagatedUserEnvPkgs = [ cosmic-ext-alternative-startup ];

      dontUseJustBuild = true;
      dontUseJustCheck = true;
      dontUseJustInstall = true;

      installPhase = ''
        runHook preInstall
        just prefix=${placeholder "out"} install-${name}
        runHook postInstall
      '';

      passthru.providedSessions = [ "cosmic-ext-${name}" ];

      meta = {
        description = "Unofficial ${compositorName} alternative session for COSMIC Desktop";
        homepage = "https://github.com/drakulix/cosmic-ext-extra-sessions";
        license = lib.licenses.gpl3Only;
        mainProgram = "start-cosmic-ext-${name}";
        maintainers = with lib.maintainers; [ HeitorAugustoLN ];
        platforms = lib.platforms.linux;
        sourceProvenance = [ lib.sourceTypes.fromSource ];
      };
    };

  sessions = {
    miracle = makeSession {
      compositorName = "Miracle";
      name = "miracle";
    };

    niri = makeSession {
      compositorName = "Niri";
      name = "niri";
    };

    sway =
      (makeSession {
        compositorName = "Sway";
        name = "sway";
      }).overrideAttrs
        (
          finalAttrs: oldAttrs: {
            prePatch = ''
              substituteInPlace sway/config-cosmic \
                --replace-fail 'exec /usr/bin/cosmic-ext-alternative-startup' 'exec cosmic-ext-alternative-startup' \
                --replace-fail 'exec /usr/bin/cosmic-ext-sway-daemon' 'exec cosmic-ext-sway-daemon'
              substituteInPlace sway/start-cosmic-ext-sway \
                --replace-fail '/etc/sway/config-cosmic' '${placeholder "out"}/etc/sway/config-cosmic'
            '';

            propagatedUserEnvPkgs = oldAttrs.propagatedUserEnvPkgs ++ [
              finalAttrs.passthru.cosmic-ext-sway-daemon
            ];

            # Install manually to avoid cosmic-ext-sway-daemon install
            installPhase = ''
              runHook preInstall

              install -Dm0644 sway/config-cosmic $out/etc/sway/config-cosmic
              install -Dm0644 sway/cosmic-ext-sway.desktop $out/share/wayland-sessions/cosmic-ext-sway.desktop
              install -Dm0755 sway/start-cosmic-ext-sway ''${!outputBin}/bin/start-cosmic-ext-sway

              runHook postInstall
            '';

            passthru = {
              cosmic-ext-sway-daemon = rustPlatform.buildRustPackage (finalAttrs: {
                pname = "cosmic-ext-sway-daemon";
                inherit (oldAttrs) meta src version;

                useFetchCargoVendor = true;
                cargoHash = "sha256-JDZecMs9lfeRT0MA30CaHCJTEwdNM2jNR26VSPPnlQE=";

                sourceRoot = "${finalAttrs.src.name}/sway/cosmic-ext-sway-daemon";
              });

              providedSessions = [ "cosmic-ext-sway" ];
            };
          }
        );
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
      lib.concatLists
    ];

    updateScript = nix-update-script {
      attrPath = "cosmic-ext-extra-sessions.sway.cosmic-ext-sway-daemon";

      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };
  };

  meta = {
    description = "Unofficial alternative sessions for COSMIC Desktop";
    homepage = "https://github.com/drakulix/cosmic-ext-extra-sessions";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
