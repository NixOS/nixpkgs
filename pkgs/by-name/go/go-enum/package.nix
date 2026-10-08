{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-enum";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fFMTnbQ6RUGxvANHveB1YrXlppgUVTJIRB4v1sV3GH8=";
  };

  vendorHash = "sha256-hGfwb0GZCxc3EQWvxs7/fNVEVGGQE2I0B+MMaH7ecPM=";

  __structuredAttrs = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
    "-X main.builtBy=nixpkgs"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Enum generator for go";
    homepage = "https://github.com/abice/go-enum";
    changelog = "https://github.com/abice/go-enum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "go-enum";
    maintainers = with lib.maintainers; [ Nadim147c ];
    platforms = lib.platforms.unix;
  };
})
