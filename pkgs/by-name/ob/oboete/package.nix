{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oboete";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "oboete";
    tag = finalAttrs.version;
    hash = "sha256-I62DQovTa9QWlmA4amnOnp2vomw4/fQuRnj2kY/tdm8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HV0Q44T9eSEg/MYpFnRCcifsRfZDlvHJ9viCiC1ouUI=";

  nativeBuildInputs = [ libcosmicAppHook ];

  buildInputs = [ sqlite ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple flashcards application for the COSMIC™ desktop written in Rust";
    homepage = "https://github.com/mariinkys/oboete";
    changelog = "https://github.com/mariinkys/oboete/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
    mainProgram = "oboete";
  };
})
