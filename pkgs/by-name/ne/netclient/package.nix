{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, stdenv
, darwin
}:

buildGoModule rec {
  pname = "netclient";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-p7cPOPmD/13Mvp0aHRDj3MXfkiaimqrTeg9D7bRU3AM=";
  };

  vendorHash = "sha256-mxDhjvNrV4oMHKHQHaxg35Tn30czmjGD3MTRh/Dexv4=";

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Cocoa
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
