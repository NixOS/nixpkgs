{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.15.6";

  src = fetchFromGitHub {
    repo = "oauth2-proxy";
    owner = "oauth2-proxy";
    sha256 = "sha256-MKKJol0nK/isXqYwemvASI/DPIhGKvCUHrFfT3Y+LQM=";
    rev = "v${version}";
  };

  vendorHash = "sha256-KAMFvTbJ3v5Vast4BoKtCpMHHZisva5RjrTY4wzlgiQ=";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  ldflags = [ "-X github.com/oauth2-proxy/oauth2-proxy/v7/pkg/version.VERSION=v${version}" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Reverse proxy that provides authentication with Google, GitHub, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = lib.licenses.mit;
    mainProgram = "oauth2-proxy";
    maintainers = with lib.maintainers; [
      swarsel
    ];
  };
}
