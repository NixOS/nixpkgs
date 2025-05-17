{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ldk-node";
  version = "v0.0.0-20250212145657-5103098fe571";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node";
    rev = version;
    hash = "sha256-wwJnZVIARPKu39aUKMcOUWfPFQhnICsFnWorQJJ6aSQ=";
  };

  buildFeatures = [ "uniffi" ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-KiEY3GwRA4Av+6UUQ1diuTq6jh1tMyfI0cHri0lWNEc=";

  # Skip tests because they download bitcoin-core and electrs zip files, and then fail
  doCheck = false;

  meta = {
    description = "Embeds the LDK node implementation compiled as shared library objects";
    homepage = "https://github.com/getAlby/ldk-node";
    changelog = "https://github.com/getAlby/ldk-node/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ bleetube ];
  };
}
