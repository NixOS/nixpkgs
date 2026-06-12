{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  coreutils,
  polkit-stdin-agent,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "run0-sudo-shim";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "LordGrimmauld";
    repo = "run0-sudo-shim";
    tag = finalAttrs.version;
    hash = "sha256-QkDoEBgcWh/eKX8jxctMNEy08Sf8kpxXFhWbsygTWz8=";
  };

  cargoHash = "sha256-ly2e2x1Z1XEXblGqWi+/r5q2FmvpekVfzGVGm+S1xio=";

  __structuredAttrs = true;

  env = {
    POLKIT_STDIN_AGENT = lib.getExe polkit-stdin-agent;
    TRUE = lib.getExe' coreutils "true";
  };

  postInstall = ''
    ln -s $out/bin/run0-sudo-shim $out/bin/sudo
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Shim for the sudo command that utilizes run0";
    changelog = "https://github.com/LordGrimmauld/run0-sudo-shim/releases/tag/${finalAttrs.version}";
    mainProgram = "sudo";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      zimward
      kuflierl
      grimmauld
    ];
  };
})
