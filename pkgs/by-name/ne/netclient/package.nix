{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  stdenv,
}:

buildGoModule rec {
  pname = "netclient";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-gQvMT7hyh1yF/cS8+fXI4en1lj3dXyZ8/3LxrFwJos0=";
  };

  vendorHash = "sha256-OzIp6tVVVh4xWuzaGI4FasCz5dMZQmRxeLqZhg/AgN0=";

  buildInputs = lib.optional stdenv.hostPlatform.isLinux libX11;

  meta = {
    description = "Automated WireGuard® Management Client";
    mainProgram = "netclient";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netclient/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wexder ];
  };
}
