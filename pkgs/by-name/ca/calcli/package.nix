{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "CalCLI";
  version = "0.0.6-unstable-2025-03-27";

  src = fetchFromGitHub {
    owner = "n0rdy";
    repo = "calcli";
    rev = "62dd0320602691672de5c0dd3074502882a8e316";
    hash = "sha256-m970M/BlL1Z7D7/DhOtZVNO+qkKhlU+DAlpzrYMMOVw=";
  };

  vendorHash = "sha256-knNmeM/i9ltdaxmLSsfQA/gK6Uwb4Of9r9cxXKkXP5Y=";

  meta = {
    description = "Cross-platform CLI calculator app with a rich set of features";
    homepage = "https://github.com/n0rdy/calcli";
    license = lib.licenses.agpl3Only;
    mainProgram = "calcli";
    maintainers = with lib.maintainers; [
      arne-zillhardt
    ];
  };
}
