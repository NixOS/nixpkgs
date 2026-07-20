{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  apple-sdk_15,
  versionCheckHook,
  llvmPackages,
}:

let
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sketchybar";
  version = "2.24.0";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5tyc/yYzdV/3JTtujuj7le/14XkC7TlN/nZg7tOZsNg=";
  };

  nativeBuildInputs = [
    # TODO: Remove once #536365 reaches this branch
    llvmPackages.lld
  ];

  buildInputs = [
    apple-sdk_15
  ];

  makeFlags = [ "arm64" ];

  # TODO: Remove once #536365 reaches this branch
  env.NIX_CFLAGS_LINK = "-fuse-ld=lld";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./bin/sketchybar $out/bin/sketchybar

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Highly customizable macOS status bar replacement";
    homepage = "https://github.com/FelixKratz/SketchyBar";
    changelog = "https://github.com/FelixKratz/SketchyBar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    mainProgram = "sketchybar";
    maintainers = with lib.maintainers; [
      azuwis
      khaneliman
    ];
    platforms = lib.platforms.darwin;
  };
})
