{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  testers,
  avml,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avml";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "avml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ziK2s4Wwy+WB45O7OU3TKyTujrLsQV6hRUSm5Jr4NO4=";
  };

  cargoHash = "sha256-72c2914higGji0vDUwjtQoil/LdEaECv+HqANTcSRdE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  passthru.tests.version = testers.testVersion { package = avml; };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Portable volatile memory acquisition tool for Linux";
    homepage = "https://github.com/microsoft/avml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lesuisse ];
    platforms = lib.platforms.linux;
    mainProgram = "avml";
  };
})
