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
  version = "0-unstable-2026-07-28";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jennings";
    repo = "jj-spr";
    rev = "998ee83de8d7dee301a0109cc3feed421c86cae0";
    hash = "sha256-djt781zEGhvhsI9CnFxCkopICFHg/hLpo2RK2HO0mfY=";
  };

  cargoHash = "sha256-4fRM2fMlEFM9d/W4QyBrBebtsQpPuq4hELKQBU74FLE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    zlib
  ];

  nativeCheckInputs = [ jujutsu ];
  doCheck = false; # FIXME: https://github.com/jennings/jj-spr/issues/102

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Power tool for Jujutsu + GitHub workflows";
    longDescription = ''
      Super Pull Requests (SPR) is the power tool for Jujutsu + GitHub
      workflows.  It enables amend-friendly single PRs and effortless
      stacked PRs, bridging the gap between Jujutsu’s change-based
      workflow and GitHub’s pull request model.
    '';
    homepage = "https://jennings.io/jj-spr/";
    changelog = "https://github.com/jennings/jj-spr/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "jj-spr";
  };
})
