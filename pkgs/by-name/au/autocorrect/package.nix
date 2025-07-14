{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autocorrect";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "huacnlee";
    repo = "autocorrect";
    rev = "5af1bc295d48b0fd04f7dbc35ea99d479f682e78";
    hash = "sha256-tbN+48a8NnwirJqUci0LgxsvJI0KzuG/aDvV/Yr8Xu8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cEiIs7wvfjP5/tkRtYb2XEZfssw09zkbOrqZsOX9ajQ=";

  cargoBuildFlags = [
    "-p"
    "autocorrect-cli"
  ];
  cargoTestFlags = [
    "-p"
    "autocorrect-cli"
  ];

  meta = {
    description = "Linter and formatter for help you improve copywriting, to correct spaces, punctuations between CJK (Chinese, Japanese, Korean)";
    mainProgram = "autocorrect";
    homepage = "https://huacnlee.github.io/autocorrect";
    changelog = "https://github.com/huacnlee/autocorrect/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ definfo ];
  };
})
