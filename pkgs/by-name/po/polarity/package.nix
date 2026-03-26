{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polarity";
  version = "latest-unstable-2026-03-23";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "134d730457e0e874308d0f0abab4600eb89bf084";
    hash = "sha256-EzPNv9GmHqIcSkADEVDBLzlWD/kubQIWBfYeCWowAhw=";
  };

  cargoHash = "sha256-eat5XK8GZlbdPdkcrvOF99ln0a2SHZexAnqH55i8Vec=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
})
