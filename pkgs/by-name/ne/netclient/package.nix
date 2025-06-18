{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  stdenv,
}:

buildGoModule rec {
  pname = "netclient";
  version = "0.90.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-/drujpz0oeAZmV24Fxy3N6aqa5z72WiVxkjccbc6xmE=";
  };

  vendorHash = "sha256-l2Vx1lD+LF/4N0QLVTDD1/TmWpR3JPAgMyrgw7aT2EQ=";

  buildInputs = lib.optional stdenv.hostPlatform.isLinux libX11;

  hardeningEnabled = [ "pie" ];

  meta = {
    description = "Automated WireGuard® Management Client";
    mainProgram = "netclient";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netclient/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wexder ];
  };
}
