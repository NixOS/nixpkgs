{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kaput-cli";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "davidchalifoux";
    repo = "kaput-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dDDwupYg+JiK7fS/9lxw/qV9/JEv5WeKS+2lwzDBPcE=";
  };

  cargoHash = "sha256-+CxIeNioN3JfINXkb3gMgyEJyCVPwbinIEr1S0IoSOk=";

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/davidchalifoux/kaput-cli/releases/tag/v${finalAttrs.version}";
    description = "Unofficial CLI client for Put.io";
    homepage = "https://kaput.sh/";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "kaput";
  };
})
