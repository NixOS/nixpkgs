{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:
let
  pname = "abctl";
  version = "0.13.1";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "airbytehq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZZP5wXsPtqkZd/sdj/LU8M/DYv0gjIWRspAFrp3ETH8=";
  };

  vendorHash = "sha256-uvOKH/MLIoIwYClpTIj010os9dGkkZPAVV0RYBjjzVk=";

  meta = {
    description = "Airbyte's CLI for managing local Airbyte installations";
    homepage = "https://airbyte.com/";
    changelog = "https://github.com/airbytehq/abctl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xelden ];
    mainProgram = "abctl";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
