{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mqattack";
  version = "0.1.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "mqattack";
    tag = finalAttrs.version;
    hash = "sha256-Pt3RMxx7ljLuz6q0Rpm20BUsN4CbL1CxHUwItB5F2mg=";
  };

  cargoHash = "sha256-ZZEKx11vivU8XsASXVydO3GVlVblP25MHA//4599jmQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MQTT penetration testing tool";
    homepage = "https://github.com/affolter-engineering/mqattack";
    changelog = "https://github.com/affolter-engineering/mqattack/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mqattack";
  };
})
