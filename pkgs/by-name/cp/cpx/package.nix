{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cpx";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "11happy";
    repo = "cpx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pQ8Z/0zlxuWiGfWBE5hA1mj/G7Zc2WSK41uu5PN1bfs=";
  };

  cargoHash = "sha256-vf4uOZBfV6aUIC07pmk+D2izqKIw9AvCrHYCU+Dyysc=";

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/11happy/cpx/releases/tag/v${finalAttrs.version}";
    description = "File copy tool for Linux with progress bars, resume capability";
    homepage = "https://github.com/11happy/cpx";
    license = lib.licenses.mit;
    mainProgram = "cpx";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.linux;
  };
})
