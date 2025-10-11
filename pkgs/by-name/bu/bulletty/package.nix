{
  lib,
  pkgs,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bulletty";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "CrociDB";
    repo = "bulletty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MVXz3ozAL26EYWAsarFbRR0cmAtaRpxcQROsLye56yE=";
  };

  cargoHash = "sha256-Q9h9VUTeFvP6pkQKj7y2pKVpoeg1hyoAbXMhAaO5zh8=";

  # perl is required for bulletty package build for openssl
  nativeBuildInputs = with pkgs; [
    perl
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "bulletty is a feed reader for the terminal";
    homepage = "https://bulletty.croci.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.FKouhai ];
  };
})
