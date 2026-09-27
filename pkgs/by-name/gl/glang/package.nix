{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  openssl,
  stdenvNoCC,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "glang";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "george-language";
    repo = "glang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JFY0Z4m83xOFOOUEmvmZXVFodOB9NIEvmkQBftR9uN8=";
  };

  cargoHash = "sha256-6koca2gieH3EEPGkWXdmTuIZqUtO4A1eOrs+KMXoReo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  patches = [
    # Remove glang > 0.1.2
    (fetchpatch2 {
      url = "https://github.com/george-language/glang/commit/62062b11af26c3d54e9a27b392d14ba4a31767b6.patch";
      hash = "sha256-l6w3vYL/QSrGDGkSGCiGn20HeXGtj+JFFAZA+bHHjM8=";
    })
  ];

  doInstallCheck = !stdenvNoCC.hostPlatform.isDarwin;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dog-themed interpreted language for beginners";
    homepage = "https://github.com/george-language/glang";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "glang";
  };
})
