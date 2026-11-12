{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "igrep";
  version = "1.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "konradsz";
    repo = "igrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZZhzBGLpzd9+rok+S/ypKpWXVzXaA1CnviC7LfgP/CU=";
  };

  cargoHash = "sha256-NZN9pB9McZkTlpGgAbxi8bwn+aRiPMymGmBLYBc6bmw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ oniguruma ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Interactive Grep";
    homepage = "https://github.com/konradsz/igrep";
    changelog = "https://github.com/konradsz/igrep/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "ig";
  };
})
