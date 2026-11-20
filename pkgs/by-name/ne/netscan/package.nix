{
  lib,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netscan";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "netscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eWUUEdin8v8NIDEDJaHzKYaMyHeyp6d0ar23GkWvZLY=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-4mhVNr62NrCPR5W7Qkfg2LAPInOltyfG/nyITROEKJY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ];

  nativeCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-V" ];

  meta = {
    description = "TUI workflow for nmap with scan history";
    homepage = "https://github.com/matthart1983/netscan";
    changelog = "https://github.com/matthart1983/netscan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "netscan";
  };
})
