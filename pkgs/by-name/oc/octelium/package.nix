{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "octelium";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "octelium";
    repo = "octelium";
    rev = "v${version}";
    hash = "sha256-fleNaCwuDLUnsQeyQhxkxJ0oST4X9+qLdON9+9ZdYwo=";
  };

  meta = {
    description = "A next-gen FOSS self-hosted unified zero trust secure access platform that can operate as a remote access VPN, a ZTNA platform, API/AI/MCP gateway, a PaaS, an ngrok-alternative and a homelab infrastructure";
    homepage = "https://github.com/octelium/octelium";
    license = with lib.licenses; [
      agpl3Only
      asl20
    ];
    maintainers = [ ];
    mainProgram = "octelium";
    platforms = lib.platforms.all;
  };
}
