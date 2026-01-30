{
  rustPlatform,
  fetchFromGitHub,
  lib,
  pkg-config,
  openssl,
  fontconfig,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emissary";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "altonen";
    repo = "emissary";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A3Kkod2oQdprswoEY9Z6A5r2PsHMUEwqyDB8ycSEUqQ=";
  };
  cargoHash = "sha256-alruzRWeLGwfiX/kj7grC7+fgu6i0/T/EJwrF/0VDtw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    fontconfig
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/altonen/emissary/releases/tag/${finalAttrs.version}";
    description = "Rust implementation of the I2P protocol stack";
    homepage = "https://altonen.github.io/emissary/";
    license = lib.licenses.mit; # https://github.com/altonen/emissary/blob/master/LICENSE (found an apache2 as well but thats for https://github.com/altonen/emissary/commit/c4a1c849ebfceba892adce53f512f1f099721de2)
    mainProgram = "emissary-cli";
    maintainers = [ lib.maintainers.N4CH723HR3R ];
  };
})
