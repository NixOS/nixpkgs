{
  lib,
  fetchFromGitHub,
  gitUpdater,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "keyscope";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "spectralops";
    repo = "keyscope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PjuBRxW42DIOyHPqs5sOFBUrPPzVVoYAeKtyIWfA+28=";
  };

  cargoHash = "sha256-Oi/F89uRuwqWTa7E/PDVdj/VAnYYeG0BSs+pM41AXCU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # build script tries to get information from git
  postPatch = ''
    echo "fn main() {}" > build.rs
  '';

  env.VERGEN_GIT_SEMVER = "v${finalAttrs.version}";

  # Test require network access
  doCheck = false;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Key and secret workflow (validation, invalidation, etc.) tool";
    homepage = "https://github.com/spectralops/keyscope";
    changelog = "https://github.com/spectralops/keyscope/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "keyscope";
  };
})
