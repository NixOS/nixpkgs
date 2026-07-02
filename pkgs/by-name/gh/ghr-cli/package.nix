{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  gitMinimal,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghr-cli";
  version = "0.8.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chenyukang";
    repo = "ghr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ELYWoGUP6s2Trtnk9zgDLlT7MtaiHzfsFbzH+LmsKDE=";
  };

  cargoHash = "sha256-siMxS08K+7L8f9A32gEWwQF9PAQh5UPMA+xTkTlz13o=";

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
