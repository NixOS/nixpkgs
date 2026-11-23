{
  lib,
  aws-lc,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hvt";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "hvt";
    tag = finalAttrs.version;
    hash = "sha256-v2OKuUxl8bAM1CuFUw67ZPS4hjNmYxBJOB0vP7+mTlk=";
  };

  cargoHash = "sha256-dXFeeJuIZX/FKQgB99n4e8Rh4UavlTh8BjGWJ8DQRVw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to do HTTP Verb Tampering";
    homepage = "https://github.com/affolter-engineering/hvt";
    changelog = "https://github.com/affolter-engineering/hvt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "hvt";
  };
})
