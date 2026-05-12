{
  lib,
  fetchFromGitHub,
  rustPlatform,
  rustc,
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
      hash = "sha256-qs6WjgiK2AFhGlbsl85fEmVaWr/aw5pOIaKw68rsLZ0=";
    };

    rosec_pam = stdenv.mkDerivation {
      pname = "pam_rosec";
      inherit version src;
      sourceRoot = "${src.name}/contrib/pam";

      buildInputs = [ pam ];

      makeFlags = [
        "PREFIX=$(out)"
        "ROSEC_PAM_UNLOCK_PATH=${rosec_core}/libexec/rosec/rosec-pam-unlock"
      ];

      installPhase = ''
        runHook preInstall
        install -Dm755 pam_rosec.so "$out/lib/security/pam_rosec.so"
        runHook postInstall
      '';
    };

    rosec_core = rustPlatform.buildRustPackage {
      pname = "rosec-unwrapped";
      inherit version src;

      cargoHash = "sha256-kE3qpdQGvXtjlospxSeoyPIUNyioLq5Ao5y94yIsjMs=";

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
      '';

      postInstall = ''
        mkdir -p $out/libexec/rosec
        mkdir -p $out/lib/rosec/providers
        mkdir -p $out/share/dbus-1/system.d
        mkdir -p $out/share/systemd/user

        mv $out/bin/rosec-pam-unlock $out/libexec/rosec/

        XDG_CONFIG_HOME=$out/lib XDG_DATA_HOME=$out/share $out/bin/rosec enable
      '';
    };
  in
  {
    pname = "rosec";
    version = "0.0.28";

    paths = [
      rosec_core
      rosec_pam
    ]
    ++ provider;

    strictDeps = true;

    passthru = {
      tests = { inherit (nixosTests) rosec; };
      inherit rosec_core src version;
      updateScript = nix-update-script {
        extraArgs = [
          "--subpackage"
          "rosec_core"
        ];
      };
    };

    __structuredAttrs = true;

    meta = {
      description = "A secrets daemon implementing the freedesktop.org Secret Service API with modular backend providers";
      homepage = "https://github.com/jmylchreest/rosec";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ mikilio ];
      platforms = lib.platforms.linux;
      mainProgram = "rosec";
    };
  }
)
