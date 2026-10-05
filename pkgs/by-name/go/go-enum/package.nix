{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-enum";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pEBx5292R8X06TLpv8kboNafiEfq9NWXvUoVVVQ0DVg=";
  };

  vendorHash = "sha256-NK4IeOmpzioo7c9PrncgwhCsIyt31sMnkv7qjuJbREo=";

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
