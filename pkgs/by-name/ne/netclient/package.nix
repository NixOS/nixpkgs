{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  stdenv,
}:

buildGoModule rec {
  pname = "netclient";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-qIrLutx30Gxzx/5jyMtbBIxEXZJ6nK9ci5HLPShlMPM=";
  };

  vendorHash = "sha256-i+J/Cs+9DN7K0aE8NBOpEkSX1QqvMYXBOCnkpi3UjHA=";

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
