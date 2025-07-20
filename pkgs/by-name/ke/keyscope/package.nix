{
  lib,
  fetchFromGitHub,
  gitUpdater,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "keyscope";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "spectralops";
    repo = "keyscope";
    tag = "v${version}";
    hash = "sha256-2DhKiQixhTCQD/SYIQa+o1kzEsslu6wAReuWr0rTrH8=";
  };

  cargoHash = "sha256-f4r0zZTkVDfycrGqRCaBQrncpAm0NP6XYkj3w7fzQeY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # build script tries to get information from git
  postPatch = ''
    echo "fn main() {}" > build.rs
  '';

  VERGEN_GIT_SEMVER = "v${version}";

  # Test require network access
  doCheck = false;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Key and secret workflow (validation, invalidation, etc.) tool";
    homepage = "https://github.com/spectralops/keyscope";
    changelog = "https://github.com/spectralops/keyscope/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "keyscope";
  };
}
