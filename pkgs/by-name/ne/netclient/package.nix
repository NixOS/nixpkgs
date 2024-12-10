{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  stdenv,
  darwin,
}:

buildGoModule rec {
  pname = "netclient";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-oS0DqrlOyab0MS7qSEquEIixcOYnlGuCYtCBmfEURm0=";
  };

  vendorHash = "sha256-09pRwsB2ycB/MK3isXZLBZDpga95SHYkNPjWWYtUuoU=";

  buildInputs =
    lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Cocoa
    ++ lib.optional stdenv.isLinux libX11;

  hardeningEnabled = [ "pie" ];

  meta = with lib; {
    description = "Automated WireGuard® Management Client";
    mainProgram = "netclient";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netclient/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ wexder ];
  };
}
