{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libx11,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "netclient";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BhaWOfiGnkPn/G5uhVNX3RAz4XFllAl5b8RzfjafsU4=";
  };

  vendorHash = "sha256-Kac28wOpmOmu1Ud/WRCJ35+yzocVLwyTKTPKkDVmmQI=";

  buildInputs = lib.optional stdenv.hostPlatform.isLinux libx11;

  meta = {
    description = "Automated WireGuard® Management Client";
    mainProgram = "netclient";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netclient/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wexder ];
  };
})
