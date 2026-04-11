{
  lib,
  rustPlatform,
  fetchFromGitLab,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-variables";
  version = "0.4.1";

  src = fetchFromGitLab {
    owner = "tglman";
    repo = "mdbook-variables";
    rev = finalAttrs.version;
    hash = "sha256-DMfVviMVizxtkunu3DygL1t0vTW6a+frfFfVl8h7Urw=";
  };

  cargoHash = "sha256-q8UbL1zBb1InYutgM3ZE7z9NdJKi68yjR2Za/o0jg9c=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "mdBook preprocessor to replace values with env variables";
    mainProgram = "mdbook-variables";
    homepage = "https://gitlab.com/tglman/mdbook-variables";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ kraftnix ];
  };
})
