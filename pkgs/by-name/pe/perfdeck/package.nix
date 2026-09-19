{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "perfdeck";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "sumant1122";
    repo = "perfdeck";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-4yvM7OvDmisfuToilHpWwnw6SL2292Gz2E5xyKn0SAo=";
  };

  vendorHash = "sha256-JAQdK+j1JZLxs34j4TBX/ElBmXBuhp9GQUIbvHuHK/8=";
  subPackages = [ "." ];
  passthru.updateScript = nix-update-script { };
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Modern, lightweight, and customizable TUI performance monitor";
    mainProgram = "perfdeck";
    homepage = "https://github.com/sumant1122/perfdeck";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ FKouhai ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
