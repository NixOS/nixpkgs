{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.15.5";

  src = fetchFromGitHub {
    repo = "oauth2-proxy";
    owner = "oauth2-proxy";
    hash = "sha256-X63Bea/0ZiyqbNt6B+3J//dGkAmbT1Qon9hCsGJEVqo=";
    rev = "v${version}";
  };

  vendorHash = "sha256-tgSu/YWL+cvsTs9QUo157dfVIZkPoyux4rgvhMvflMY=";

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
