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

  doCheck = !stdenvNoCC.hostPlatform.isDarwin; # https://github.com/george-language/glang/issues/41
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
