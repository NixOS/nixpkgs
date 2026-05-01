{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libx11,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "netclient";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3WQbOfgJDzry/2NdXu8CIAQqoCvmaGy1+WsojmHCXIU=";
  };

  vendorHash = "sha256-PzbMmhAAfh0piTHZ7zcC45nYBEUhPzjK2/ICQ9VmdsE=";

  buildInputs = lib.optional stdenv.hostPlatform.isLinux libx11;

  meta = {
    description = "Automated WireGuard® Management Client";
    mainProgram = "netclient";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netclient/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wexder ];
  };
})
