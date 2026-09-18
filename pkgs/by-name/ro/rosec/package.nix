{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  autoPatchelfHook,
  symlinkJoin,
  pam,
  dbus,
  wayland,
  libxkbcommon,
  nixosTests,
  nix-update-script,
  provider ? [ ],
}:
symlinkJoin (
  finalAttrs:
  let
    inherit (finalAttrs) version;

    src = fetchFromGitHub {
      owner = "jmylchreest";
      repo = "rosec";
      tag = "v${version}";
      hash = "sha256-dlHOzUW/kH9SS/mPl+VvEetCzOY/L2qEpoYLJTCWR90=";
    };

    rosecPam = stdenv.mkDerivation {
      pname = "pam_rosec";
      inherit version src;
      sourceRoot = "${src.name}/contrib/pam";

      buildInputs = [ pam ];

      makeFlags = [
        "PREFIX=$(out)"
        "ROSEC_PAM_UNLOCK_PATH=${rosecCore}/libexec/rosec/rosec-pam-unlock"
      ];

      installPhase = ''
        runHook preInstall
        install -Dm755 pam_rosec.so "$out/lib/security/pam_rosec.so"
        runHook postInstall
      '';
    };

    rosecCore = rustPlatform.buildRustPackage {
      pname = "rosec-unwrapped";
      inherit version src;

      cargoHash = "sha256-X1LEL8/ntKkdRQLU+XBJ7oaDhNph2WAeVWVJ2KnzVzA=";

      nativeBuildInputs = [
        autoPatchelfHook
        dbus
      ];

      runtimeDependencies = [
        libxkbcommon
        wayland
      ];

      buildInputs = [
        stdenv.cc.cc.lib
      ];

      preCheck = ''
        export $(dbus-launch --config-file=${dbus}/share/dbus-1/session.conf)
        # rosec-vault sidecar tests require writable xdg data directory
        export XDG_DATA_HOME=$TMPDIR/xdg-data
      '';

      postInstall = ''
        mkdir -p $out/libexec/rosec
        mkdir -p $out/lib/rosec/providers
        mkdir -p $out/share/dbus-1/system.d
        mkdir -p $out/share/systemd/user

        mv $out/bin/rosec-pam-unlock $out/libexec/rosec/

        # `rosec enable` writes the D-Bus, systemd user unit and xdg portal
        # registrations to $XDG_CONFIG_HOME and $XDG_DATA_HOME, which are
        # redirected into the output here.
        XDG_CONFIG_HOME=$out/lib XDG_DATA_HOME=$out/share $out/bin/rosec enable
      '';
    };
  in
  {
    pname = "rosec";
    version = "0.0.34";

    paths = [
      rosecCore
      rosecPam
    ]
    ++ provider;

    __structuredAttrs = true;
    strictDeps = true;

    passthru = {
      tests = { inherit (nixosTests) rosec; };
      inherit rosecCore src version;
      updateScript = nix-update-script {
        extraArgs = [
          "--subpackage"
          "rosecCore"
        ];
      };
    };

    meta = {
      description = "Secrets daemon implementing the freedesktop.org Secret Service API with modular backend providers";
      homepage = "https://github.com/jmylchreest/rosec";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ mikilio ];
      platforms = lib.platforms.linux;
      mainProgram = "rosec";
    };
  }
)
