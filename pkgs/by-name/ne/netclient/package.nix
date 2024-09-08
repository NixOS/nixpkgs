{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, stdenv
, darwin
}:

buildGoModule rec {
  pname = "netclient";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-cc0OBDDyg+egnQWPoteGVVHtg8vfYC9RVIpe7A+ZJPQ=";
  };

  vendorHash = "sha256-DzTTESPxYuZYNGjEG3PufLoS02+R9275arVcUzImpBU=";

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
