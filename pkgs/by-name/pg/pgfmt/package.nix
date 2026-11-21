{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "pgfmt";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "gmr";
    repo = "pgfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JSV8cR54q0787617NyWDwJsse1hOwUr0yhzbjBxHbkA=";
  };

  cargoHash = "sha256-JNd30468A8HhTjNC7g4L4oknXkqH9DgmiqHa8XdmCXk=";

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
