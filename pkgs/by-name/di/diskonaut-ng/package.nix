{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {

  __structuredAttrs = true;

  pname = "diskonaut-ng";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "neunenak";
    repo = "diskonaut";
    tag = finalAttrs.version;
    hash = "sha256-4gfJnqACJP1lV62Bkuarp85Idoh/H8zQ5W085yNZR5Q=";
  };

  cargoHash = "sha256-+NwZbR3fRj8Wi95GtsUQFWOyaZ0ekC4chsoJ5rsH3Zg=";

  # 1 passed; 44 failed https://hydra.nixos.org/build/148943783/nixlog/1
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal disk space navigator";
    homepage = "https://github.com/neunenak/diskonaut";
    changelog = "https://github.com/neunenak/diskonaut/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gregshuflin
    ];
    mainProgram = "diskonaut";
  };
})
