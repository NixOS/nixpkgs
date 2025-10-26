{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dness";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "nickbabcock";
    repo = "dness";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vty4ec6aoUh3p2b9vLkNeS5R4pJWzjwYrC5DtVVyhT8=";
  };

  cargoHash = "sha256-WhSeNukPjgM7Cy8LWi/s1YGa5/UxsFU1NGL7vIUlU58=";

  doCheck = false; # Many tests require network access

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamic DNS updating tool supporting a variety of providers";
    homepage = "https://github.com/nickbabcock/dness";
    maintainers = with lib.maintainers; [ logan-barnett ];
    mainProgram = "dness";
    license = lib.licenses.mit;
  };
})
