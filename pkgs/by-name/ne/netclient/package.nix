{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  stdenv,
}:

buildGoModule rec {
  pname = "netclient";
  version = "0.99.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-hSylhELMfiYNFHt03bJN1gTfy3EXSHJOj+ayUeU3+4w=";
  };

  vendorHash = "sha256-bpXGXK97ohepYoAyJFZE49vo48ch3gAsVyax1+uLIfE=";

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
