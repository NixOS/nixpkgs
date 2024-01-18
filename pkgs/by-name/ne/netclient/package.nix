{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, stdenv
, darwin
}:

buildGoModule rec {
  pname = "netclient";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-yUyC6QTNhTNN/npGXiwS7M6cGKjh4H9vR8/z2/Sckz4=";
  };

  vendorHash = "sha256-cnzdqSd3KOITOAH++zxKTqvUzjFxszf/rwkCF6vDpMc=";

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Cocoa
    ++ lib.optional stdenv.isLinux libX11;

  hardeningEnabled = [ "pie" ];

  meta = with lib; {
    description = "Automated WireGuard® Management Client";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netclient/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ wexder ];
  };
}
