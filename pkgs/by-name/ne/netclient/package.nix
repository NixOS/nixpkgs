{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, stdenv
, darwin
}:

buildGoModule rec {
  pname = "netclient";
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-EwkjU4MICkCuJJ7a39dKPTuugELprHQUIyXqwmJpev8=";
  };

  vendorHash = "sha256-R/aHXZ0BM2gWouUIezYf63SMqT8vjH2ZhOItgu6RBb4=";

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
