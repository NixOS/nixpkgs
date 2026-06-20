{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  gitMinimal,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghr-cli";
  version = "0.8.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chenyukang";
    repo = "ghr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lo8a5EhLslqjnUG/xM8XFU1x1Eam47lFD8KRMzuCSD4=";
  };

  cargoHash = "sha256-PtnQVdW9yC2309047PFt/HXV1QyqNttZ0zJ8hocLRAo=";

  passthru.updateScript = nix-update-script { };

  nativeCheckInputs = [
    gitMinimal
  ];

  meta = {
    description = "Fast terminal workspace for staying on top of GitHub";
    homepage = "https://catcoding.me/ghr/";
    changelog = "https://github.com/chenyukang/ghr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pborzenkov ];
    mainProgram = "ghr";
  };
})
