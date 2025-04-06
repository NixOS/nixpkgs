{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
    hash = "sha256-A2fa1rZvxVpJ6X0s0wTDROarGX5Fxp6zKK9cWiag7TQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Pvz15q9yGqcJecOvDWXQQCEDXuSEJbJyZ8Arj8Xbyh4=";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
