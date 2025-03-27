{
  lib,
  stdenv,
  stdenvAdapters,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
  wayland,
  nix-update-script,

  withMoldLinker ? stdenv.targetPlatform.isLinux,
}:

rustPlatform.buildRustPackage.override
  { stdenv = if withMoldLinker then stdenvAdapters.useMoldLinker stdenv else stdenv; }
  (finalAttrs: {
    pname = "cosmic-randr";
    version = "1.0.0-alpha.6";

    src = fetchFromGitHub {
      owner = "pop-os";
      repo = "cosmic-randr";
      tag = "epoch-${finalAttrs.version}";
      hash = "sha256-Sqxe+vKonsK9MmJGtbrZHE7frfrjkHXysm0WQt7WSU4=";
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-UQ/fhjUiniVeHRQYulYko4OxcWB6UhFuxH1dVAfAzIY=";

    nativeBuildInputs = [
      just
      pkg-config
    ];

    buildInputs = [ wayland ];

    dontUseJustBuild = true;
    dontUseJustCheck = true;

    justFlags = [
      "--set"
      "prefix"
      (placeholder "out")
      "--set"
      "bin-src"
      "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-randr"
    ];

    env."CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
      lib.optionalString withMoldLinker "-C link-arg=-fuse-ld=mold";

    passthru.updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };

    meta = {
      homepage = "https://github.com/pop-os/cosmic-randr";
      description = "Library and utility for displaying and configuring Wayland outputs";
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [
        nyabinary
        HeitorAugustoLN
      ];
      platforms = lib.platforms.linux;
      mainProgram = "cosmic-randr";
    };
  })
