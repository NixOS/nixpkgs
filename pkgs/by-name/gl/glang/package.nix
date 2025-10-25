{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenvNoCC,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "glang";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "george-language";
    repo = "glang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q3Y+lsxvzUcHj7i7eUXVGCNTRpBgbX2wMI7tV2nXSHA=";
  };

  cargoHash = "sha256-A8tl6xxC5fc4v0Zj26wxmYMBPOsv5nJkcqNJu1PbwSc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doCheck = !stdenvNoCC.hostPlatform.isDarwin;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dog-themed, interpreted programming language for beginners.";
    homepage = "https://github.com/george-language/glang";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "glang";
  };
})
