{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mq";
  version = "0.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "harehare";
    repo = "mq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-33MTLqMxxnOtqiBNqov9H91oK11OAqusAXMAuM4u7vQ=";
  };

  cargoHash = "sha256-fxKi1X0lzv+TLSH/HerUn9tOov0++ug8KeSUGhTord4=";

  cargoBuildFlags = [
    "--package"
    "mq-run"
    "--bin"
    "mq"
  ];

  cargoTestFlags = [
    "--package"
    "mq-run"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "jq-like command-line tool for markdown processing";
    longDescription = ''
      mq is a command-line tool that processes Markdown using a syntax
      similar to jq. It allows you to easily slice, filter, map, and
      transform Markdown documents.
    '';
    homepage = "https://mqlang.org";
    changelog = "https://github.com/harehare/mq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ harehare ];
    mainProgram = "mq";
  };
})
