{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  stdenv,
}:

buildGoModule rec {
  pname = "netclient";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-vGiOVAulqngodUSOmpqMs5ZNHtUhx5TGhpihSaAo164=";
  };

  vendorHash = "sha256-ENrBJ0XbCfLfzTVZEVtDBjGxupdiLI7USGVImkYWDdY=";

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
