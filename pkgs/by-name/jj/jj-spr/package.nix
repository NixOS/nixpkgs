{
  fetchFromGitHub,
  jujutsu,
  lib,
  libgit2,
  nix-update-script,
  pkg-config,
  rustPlatform,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jj-spr";
  version = "0-unstable-2026-01-21";

  src = fetchFromGitHub {
    owner = "LucioFranco";
    repo = "jj-spr";
    rev = "982602e92542b53639679b3ce9cd71e43237a18d";
    hash = "sha256-H2aNW6brQ3gIX83gEc8PwgzuscZISFhvQeqr0wVJ17A=";
  };

  cargoHash = "sha256-3pBP8ZgKiKnE6fK4a9IVR67br33ktsmB5ofwTyy95wA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    zlib
  ];

  nativeCheckInputs = [ jujutsu ];
  doCheck = false; # FIXME: https://github.com/LucioFranco/jj-spr/issues/102

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Power tool for Jujutsu + GitHub workflows";
    longDescription = ''
      Super Pull Requests (SPR) is the power tool for Jujutsu + GitHub
      workflows.  It enables amend-friendly single PRs and effortless
      stacked PRs, bridging the gap between Jujutsu’s change-based
      workflow and GitHub’s pull request model.
    '';
    homepage = "https://luciofran.co/jj-spr";
    changelog = "https://github.com/LucioFranco/jj-spr/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "jj-spr";
  };
})
