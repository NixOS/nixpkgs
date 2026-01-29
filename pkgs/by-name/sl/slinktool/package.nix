{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slinktool";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "EarthScope";
    repo = "slinktool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4UUvjlSqtBTiO200pb4FEFXEvUAmA4OlegrgF4wZII4=";
  };

  # slinktool uses K&R-style function pointers in some places; fails with modern GCC
  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  installPhase = ''
    runHook preInstall

    install -D slinktool $out/bin/${finalAttrs.meta.mainProgram}

    runHook postInstall
  '';

  versionCheckProgramArg = "-V";
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SeedLink client for data stream inspection, data collection and server testing";
    homepage = "https://github.com/EarthScope/slinktool";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ BIOS9 ];
    platforms = lib.platforms.all;
    mainProgram = "slinktool";
  };
})
