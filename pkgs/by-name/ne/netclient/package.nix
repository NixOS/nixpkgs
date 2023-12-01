{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, stdenv
, darwin
}:

buildGoModule rec {
  pname = "netclient";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-r5Du9Gwt+deeUe6AJDN85o4snybvzZIIsyt+cfgMq2Q=";
  };

  vendorHash = "sha256-/RNteV+Ys7TVTJtQsWcGK/1C6mf/sQUahIeEzefBe3A=";

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
