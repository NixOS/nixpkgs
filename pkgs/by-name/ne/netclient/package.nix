{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  stdenv,
}:

buildGoModule rec {
  pname = "netclient";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-F9hyTjRk2gqS9Jf+2/ZVYsvltr+lohK1loCAlJGyPEk=";
  };

  vendorHash = "sha256-ccTN1/LmbriQBia/zi+66+Sd7TUs7Qdr4Cwvsp3Wv30=";

  buildInputs = lib.optional stdenv.hostPlatform.isLinux libX11;

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
