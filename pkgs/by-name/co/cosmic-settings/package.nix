{
  lib,
  stdenv,
  stdenvAdapters,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  just,
  libcosmicAppHook,
  pkg-config,
  expat,
  libinput,
  fontconfig,
  freetype,
  pipewire,
  pulseaudio,
  udev,
  util-linux,
  cosmic-randr,
  xkeyboard_config,
  nix-update-script,

  withMoldLinker ? stdenv.targetPlatform.isLinux,
}:
let
  libcosmicAppHook' = (libcosmicAppHook.__spliced.buildHost or libcosmicAppHook).override {
    includeSettings = false;
  };
in
rustPlatform.buildRustPackage.override
  { stdenv = if withMoldLinker then stdenvAdapters.useMoldLinker stdenv else stdenv; }
  (finalAttrs: {
    pname = "cosmic-settings";
    version = "1.0.0-alpha.6";

    src = fetchFromGitHub {
      owner = "pop-os";
      repo = "cosmic-settings";
      tag = "epoch-${finalAttrs.version}";
      hash = "sha256-UKg3TIpyaqtynk6wLFFPpv69F74hmqfMVPra2+iFbvE=";
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-mf/Cw3/RLrCYgsk7JKCU2+oPn1VPbD+4JzkUmbd47m8=";

    nativeBuildInputs = [
      cmake
      just
      libcosmicAppHook'
      pkg-config
      rustPlatform.bindgenHook
      util-linux
    ];

    buildInputs = [
      expat
      fontconfig
      freetype
      libinput
      pipewire
      pulseaudio
      udev
    ];

    dontUseJustBuild = true;
    dontUseJustCheck = true;

    justFlags = [
      "--set"
      "prefix"
      (placeholder "out")
      "--set"
      "bin-src"
      "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-settings"
    ];

    env."CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
      lib.optionalString withMoldLinker "-C link-arg=-fuse-ld=mold";

    preFixup = ''
      libcosmicAppWrapperArgs+=(
        --prefix PATH : ${lib.makeBinPath [ cosmic-randr ]}
        --set-default X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml
        --set-default X11_BASE_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/extra.xml
      )
    '';

    passthru.updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };

    meta = {
      description = "Settings for the COSMIC Desktop Environment";
      homepage = "https://github.com/pop-os/cosmic-settings";
      license = lib.licenses.gpl3Only;
      mainProgram = "cosmic-settings";
      maintainers = with lib.maintainers; [
        nyabinary
        HeitorAugustoLN
      ];
      platforms = lib.platforms.linux;
    };
  })
