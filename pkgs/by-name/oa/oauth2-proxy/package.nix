{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.12.0";

  src = fetchFromGitHub {
    repo = "oauth2-proxy";
    owner = "oauth2-proxy";
    sha256 = "sha256-rUjdyGv7mua/bfcxbbQQXrXiJndK3HiyNyjLVnRbuG4=";
    rev = "v${version}";
  };

  vendorHash = "sha256-6Asydomg4Xz0JciRnODJSqVBtFAmpfMjDnr1JKr222o=";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  ldflags = [ "-X github.com/oauth2-proxy/oauth2-proxy/v7/pkg/version.VERSION=v${version}" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = with lib; {
    description = "Reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = licenses.mit;
    teams = [ teams.serokell ];
    mainProgram = "oauth2-proxy";
  };
}
