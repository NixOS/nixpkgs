{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    tag = "v${version}";
    hash = "sha256-Xr4jAQ3G5El9FU6qOJJARjkZmTZly8pb//ElQizOHSg=";
  };

  cargoHash = "sha256-Di3Kqwa63AWwZE1VOal+mqmYe/nzPFqis1MnawW9uZo=";

  meta = {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "slumber";
    maintainers = with lib.maintainers; [ javaes ];
  };
}
