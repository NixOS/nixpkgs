{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "picoleaf";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "tessro";
    repo = "picoleaf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o1REM8Gfv+hJGVlo+c4gYr9U2MiTDwHLAx5SaBAN39s=";
  };

  vendorHash = "sha256-6/4xKZ/G8kTmQwdYmUOlZNQMJ/I8yThfLYjOPzyhlyQ=";

  meta = {
    description = "A tiny CLI tool for controlling Nanoleaf";
    mainProgram = "picoleaf";
    homepage = "https://github.com/tessro/picoleaf";
    changelog = "https://github.com/tessro/picoleaf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sfrijters ];
  };
})
