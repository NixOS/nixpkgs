{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sig";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "sig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-px2QdhhvBxfPCszGqeeYzsUrGwLP4DxXiKeNRAgZ23U=";
  };

  cargoHash = "sha256-dqpapu6qnWfe0vMUXpEh2lXwEV9iqIG7B+P6XQbA9Q8=";

  meta = {
    description = "Interactive grep (for streaming)";
    homepage = "https://github.com/ynqa/sig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qaidvoid ];
    mainProgram = "sig";
  };
})
