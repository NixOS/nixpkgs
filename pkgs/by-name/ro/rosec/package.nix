{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  autoPatchelfHook,
  symlinkJoin,
  pam,
  dbus,
  pkg-config,
  wayland,
  libxkbcommon,
  zstd,
  nixosTests,
  nix-update-script,
  runCommand,
  provider ? [ ],
}:
symlinkJoin (
  finalAttrs:
  let
    inherit (finalAttrs) version;

    # Upstream embeds this file at host compile time (rosec-wasm/build.rs).
    # Paths are the provider outputs themselves: discovery scans those
    # directories, and trust is the exact path plus both file hashes.
    # symlinkJoin would present a different path, which would fail closed.
    packagedProvidersManifest = runCommand "rosec-packaged-providers.json" { } ''
      set -eu
      {
        echo '['
        ${lib.concatMapStringsSep "\n        echo ','\n" (p: ''
          wasm="${p}/lib/rosec/providers/${p.rosecWasmFile}"
          policy="$wasm.policy.toml"
          test -f "$wasm"
          test -f "$policy"
          wasm_sha256=$(sha256sum "$wasm" | cut -d' ' -f1)
          policy_sha256=$(sha256sum "$policy" | cut -d' ' -f1)
          printf '  {"path":"%s","wasm_sha256":"%s","policy_sha256":"%s"}' \
            "$wasm" "$wasm_sha256" "$policy_sha256"
        '') provider}
        echo
        echo ']'
      } > "$out"
    '';

    src = fetchFromGitHub {
      owner = "jmylchreest";
      repo = "rosec";
      tag = "v${version}";
      hash = "sha256-/wMNLuy64E8Ypaw7kCkig7WXfnuk9Sl6+LY8PRYWsr8=";
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

      cargoHash = "sha256-Z/QGE5OgIKcJokPycSkgvfpiRHSU2nrSM8mbZTx1WYE=";

      nativeBuildInputs = [
        autoPatchelfHook
        dbus
        pkg-config
      ];

      runtimeDependencies = [
        libxkbcommon
        wayland
      ];

      buildInputs = [
        stdenv.cc.cc.lib
        zstd
      ];
      env = lib.optionalAttrs (provider != [ ]) {
        ROSEC_PACKAGED_PROVIDERS = packagedProvidersManifest;
      };

      preCheck = ''
        # 0.0.40 tests spawn dbus-daemon, which opens the compiled-in
        # /etc/dbus-1/session.conf and machine-id paths. The sandbox cannot
        # create those, so use a copy with equal-length replacements under /tmp.
        mkdir -p /tmp/bin /tmp/dbus-1 /tmp/lib/dbus
        cp ${dbus}/share/dbus-1/session.conf /tmp/dbus-1/session.conf
        echo 0123456789abcdef0123456789abcdef > /tmp/machine-id
        cp /tmp/machine-id /tmp/lib/dbus/machine-id
        cp ${dbus}/bin/dbus-daemon /tmp/bin/dbus-daemon
        sed -i \
          -e 's|/etc/dbus-1/session.conf|/tmp/dbus-1/session.conf|' \
          -e 's|/etc/machine-id|/tmp/machine-id|' \
          -e 's|/var/lib/dbus/machine-id|/tmp/lib/dbus/machine-id|' \
          /tmp/bin/dbus-daemon
        export PATH="/tmp/bin:$PATH"
        export HOME="$TMPDIR/home"
        mkdir -p "$HOME"
        export XDG_CACHE_HOME="$TMPDIR/cache"
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
    version = "0.0.40";

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
