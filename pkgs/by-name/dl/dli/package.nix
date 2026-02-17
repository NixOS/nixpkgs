{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "dli";
  version = "0-unstable-2025-09-06";

  src = fetchFromGitHub {
    owner = "haylinmoore";
    repo = "dli";
    rev = "176302f80cf771a7a15d9df58c3296a979f18e28";
    hash = "sha256-I8ozN5ucBhsArehSQibTLlYavq+4rBRUvU42Cli4KVo=";
  };

  vendorHash = "sha256-kgf/tt1Mr/3ja3or0zL/Mqnwy00XiGj7rdM/MnhjWZw=";

  meta = {
    description = "CLI based tool for managing DNS records";
    homepage = "https://github.com/haylinmoore/dli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "dli";
  };
}
