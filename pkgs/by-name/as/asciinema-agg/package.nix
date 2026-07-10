{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agg";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "agg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XuAVckgTsKvngrR/blgpLgONaWxfrn8o7hCKqCGPNeM=";
  };

  strictDeps = true;

  cargoHash = "sha256-VcdHlQOplki31uLOutVx7HH7rjH9a5fEZhlxtLvuS9E=";

  __impureHostDeps = lib.optionals stdenv.hostPlatform.isDarwin [
    "/System/Library/Fonts"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Command-line tool for generating animated GIF files from asciicast files produced by asciinema terminal recorder";
    homepage = "https://github.com/asciinema/agg";
    changelog = "https://github.com/asciinema/agg/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "agg";
  };
})
