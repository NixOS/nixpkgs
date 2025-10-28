{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sig";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "sig";
    rev = "v${version}";
    hash = "sha256-KxLSZ4/idlDrhRKFUsC3Ko0DcpSzwLWjees1jObC5KQ=";
  };

  cargoHash = "sha256-nlW9pXgfn/8MjFFXs+HeIiBT9Ew8M1ETtuTZg5Qa4AE=";

  meta = {
    description = "Interactive grep (for streaming)";
    homepage = "https://github.com/ynqa/sig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qaidvoid ];
    mainProgram = "sig";
  };
}
