{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustypaste";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0rS7JGJeyC6smmR4BHHx/s0Pl8YY3vJy10X+0MYPdV8=";
  };

  cargoHash = "sha256-8o6SsGyi0O15lGOaBHe8ggdJnRAKJNLmc4as2R57FaQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  dontUseCargoParallelTests = true;

  checkFlags = [
    # Tests require internet access
    "--skip=paste::tests::test_paste_data"
    "--skip=server::tests::test_upload_remote_file"
    "--skip=test_validate_remote_url_valid_http"
    "--skip=test_validate_remote_url_valid_https"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Minimal file upload/pastebin service";
    homepage = "https://github.com/orhun/rustypaste";
    changelog = "https://github.com/orhun/rustypaste/blob/v${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seqizz ];
    mainProgram = "rustypaste";
  };
})
