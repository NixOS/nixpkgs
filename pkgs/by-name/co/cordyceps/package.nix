{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cordyceps";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "lopes";
    repo = "cordyceps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fdBYjK9TyLnAWZp9oggOsPPEIs0qwrdS747RVczm+ZY=";
  };

  cargoHash = "sha256-KweJ+TObEWdiIKhacYj2XD9yNS19o2hB/rKu3QOqpe8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Learn ransomware mechanics";
    homepage = "https://github.com/lopes/cordyceps";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "cordyceps";
  };
})
