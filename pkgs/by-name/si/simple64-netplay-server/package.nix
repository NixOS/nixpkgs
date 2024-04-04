{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "simple64-netplay-server";
  version = "2024.06.1";

  src = fetchFromGitHub {
    owner = "simple64";
    repo = "simple64-netplay-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-WTEtTzRkXuIusfK6Nbj1aLwXcXyaXQi+j3SsDrvtLKo=";
  };

  vendorHash = "sha256-zfLSti368rBHj17HKDZKtOQQrhVGVa2CaieaDGHcZOk=";

  meta = {
    description = "Dedicated server for simple64 netplay";
    homepage = "https://github.com/simple64/simple64-netplay-server";
    license = lib.licenses.gpl3Only;
    mainProgram = "simple64-netplay-server";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
