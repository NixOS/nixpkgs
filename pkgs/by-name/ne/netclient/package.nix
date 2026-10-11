{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libx11,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "netclient";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OgCKcfNU0AKAbe+jrmLZ9o7J7xYxIYxcLfdtN6yYEfg=";
  };

  vendorHash = "sha256-SAJkeuDEVOqNDAUTY8ywSrnbq/lPYIbLtLGGGk882TM=";

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
