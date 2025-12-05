{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  stdenv,
}:

buildGoModule rec {
  pname = "netclient";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-ATxY4wiQoxsZs7zqdVgEWYmB87OFjLVTa45aDLXioI4=";
  };

  vendorHash = "sha256-Yj68ouZ/L6RG/DaZWWIjU8fycOoSV9A7CNc4qlzES+Q=";

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
