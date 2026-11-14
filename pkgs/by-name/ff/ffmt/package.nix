{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ffmt";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sbryngelson";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-sQqynSe5lxo6BLtNdiJPfuxTEb2Fmg4kJvuFd5rKJz0=";
  };

  cargoHash = "sha256-vK203JR8gq/KfaSNilXU7dKHLasMCglSNyvVt6roy5s=";
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, configurable Fortran formatter with Fypp, Doxygen, and OpenACC/OpenMP support";
    homepage = "https://github.com/sbryngelson/ffmt";
    changelog = "https://github.com/sbryngelson/ffmt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "ffmt";
    maintainers = with lib.maintainers; [ kleindotc ];
    platforms = lib.platforms.unix;
  };
})
