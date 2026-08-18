{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  libcosmicAppHook,
  pciutils,
  usbutils,
  util-linux,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "examine";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "examine";
    tag = finalAttrs.version;
    hash = "sha256-6U8reOzeqamX/MG/mWbso+kjuZQ6cK8j9XhuEtGZ1q4=";
  };

  cargoHash = "sha256-V+ClzaG7LnkOl84j5mVGJPTLVfaVqxaSH7ufmjXdwyM=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/examine"
  ];

  preFixup = ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        pciutils
        usbutils
        util-linux
      ]
    })
  '';

  env.VERGEN_GIT_SHA = finalAttrs.version;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/cosmic-utils/examine/releases/tag/${finalAttrs.version}";
    description = "System information viewer for the COSMIC Desktop";
    homepage = "https://github.com/cosmic-utils/examine";
    license = lib.licenses.gpl3Only;
    mainProgram = "examine";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
