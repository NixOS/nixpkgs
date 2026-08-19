{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  SDL2,
  SDL2_image,
  ffmpeg,
  cairo,
  pango,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oshu";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "fmang";
    repo = "oshu";
    tag = finalAttrs.version;
    hash = "sha256-bVMEhaSaLtlxkPnu3rtue6Ov5m+8ymteBRLnWVv0YEI=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    versionCheckHook
  ];

  buildInputs = [
    SDL2
    SDL2_image
    ffmpeg
    cairo
    pango
  ];

  cmakeFlag = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DOSHU_DEFAULT_SKIN=minimal"
  ];

  doCheck = true;
  checkTarget = "check";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight osu! client for Linux and low-end systems";
    homepage = "https://github.com/fmang/oshu";
    mainProgram = "oshu";
    changelog = "https://github.com/fmang/oshu/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ castorNova2 ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
