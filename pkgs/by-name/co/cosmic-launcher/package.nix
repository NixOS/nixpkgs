{
  lib,
  stdenv,
  stdenvAdapters,
  fetchFromGitHub,
  rustPlatform,
  just,
  libcosmicAppHook,
  nix-update-script,

  withMoldLinker ? stdenv.targetPlatform.isLinux,
}:

rustPlatform.buildRustPackage.override
  { stdenv = if withMoldLinker then stdenvAdapters.useMoldLinker stdenv else stdenv; }
  (finalAttrs: {
    pname = "cosmic-launcher";
    version = "1.0.0-alpha.6";

    src = fetchFromGitHub {
      owner = "pop-os";
      repo = "cosmic-launcher";
      tag = "epoch-${finalAttrs.version}";
      hash = "sha256-BtYnL+qkM/aw+Air5yOKH098V+TQByM5mh1DX7v+v+s=";
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-g7Qr3C8jQg65KehXAhftdXCpEukag0w12ClvZFkxfqs=";

    nativeBuildInputs = [
      just
      libcosmicAppHook
    ];

    dontUseJustBuild = true;
    dontUseJustCheck = true;

    justFlags = [
      "--set"
      "prefix"
      (placeholder "out")
      "--set"
      "bin-src"
      "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-launcher"
    ];

    env."CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
      "--cfg tokio_unstable${lib.optionalString withMoldLinker " -C link-arg=-fuse-ld=mold"}";

    passthru.updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };

    meta = {
      homepage = "https://github.com/pop-os/cosmic-launcher";
      description = "Launcher for the COSMIC Desktop Environment";
      mainProgram = "cosmic-launcher";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        nyabinary
        HeitorAugustoLN
      ];
      platforms = lib.platforms.linux;
    };
  })
