{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "pgfmt";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "gmr";
    repo = "pgfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DHSgmuqocrJoLsK1dU2jt2M4DiTupxAM42GvDx0VyI8=";
  };

  cargoHash = "sha256-crpVd2xKBtKnFJhdzB3+t1qVXGDVjrf6adGZeAOQzPg=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/gmr/pgfmt/releases/tag/${finalAttrs.src.tag}";
    description = "PostgreSQL SQL formatter";
    homepage = "https://github.com/gmr/pgfmt";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.amaidurova ];
    mainProgram = "pgfmt";
  };
})
