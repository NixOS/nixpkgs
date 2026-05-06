{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agg";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "agg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-64VyCTGjzey6AHEAfk5V/Qoffe5+sDaDNve54M7tmf4=";
  };

  strictDeps = true;

  cargoHash = "sha256-/WS5nAFKnP/CsU5+Pf5rtNN4LWaXVjlidLzH7DWYds0=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Command-line tool for generating animated GIF files from asciicast v2 files produced by asciinema terminal recorder";
    homepage = "https://github.com/asciinema/agg";
    changelog = "https://github.com/asciinema/agg/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "agg";
  };
})
