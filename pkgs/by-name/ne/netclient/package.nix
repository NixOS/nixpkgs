{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libx11,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "netclient";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JJ1YfdivmMfLX9hmbhkCwEUmEWUvxj3ZvdCwla6jSco=";
  };

  vendorHash = "sha256-iWCpAz9rG+Inxw2pzf1SRnSOOKN86+lcXV0eNYrFW5I=";

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
