{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  stdenv,
}:

buildGoModule rec {
  pname = "netclient";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netclient";
    rev = "v${version}";
    hash = "sha256-65U0cQpunLecvw7dZfBY4dFoj8Jp6+LqUWcCDfS0eSA=";
  };

  vendorHash = "sha256-XF2OVgK5OrIrKqamY20lm49OF3u3RvxcW4TTtPkr5YU=";

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
