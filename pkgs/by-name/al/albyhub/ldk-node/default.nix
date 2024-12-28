{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ldk-node";
  version = "5103098fe571742e90287a3ed1fd51b241aa10d6";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = pname;
    rev = version;
    hash = "sha256-wwJnZVIARPKu39aUKMcOUWfPFQhnICsFnWorQJJ6aSQ=";
  };

  buildFeatures = [ "uniffi" ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-KiEY3GwRA4Av+6UUQ1diuTq6jh1tMyfI0cHri0lWNEc=";

  doCheck = false;

  meta = {
    description = "Embeds the LDK node implementation compiled as shared library objects";
    homepage = "https://github.com/getAlby/ldk-node";
    changelog = "https://github.com/getAlby/ldk-node/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.x86_64 ++ lib.platforms.aarch64;
    maintainers = with lib.maintainers; [ bleetube ];
  };
}
