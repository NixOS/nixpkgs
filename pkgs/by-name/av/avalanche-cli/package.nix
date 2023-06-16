{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "avalanche-cli";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "avalanche-cli";
    tag = "v${version}";
    hash = "sha256-3Ejj3dcYWhLca2HXaqgW6eP88YxsZOaWD3H8yDk8DEM=";
  };

  proxyVendor = true;

  vendorHash = "sha256-B0D2iZQ+ov+h5+a0oFAWcWdfoHk0pJAT5DOwd9BExt0=";

  ldflags = [
    "-X=github.com/ava-labs/avalanche-cli/cmd.Version=${version}"
  ];

  doCheck = false;

  meta = {
    description = "Command line tool for Avalanche";
    homepage = "https://github.com/ava-labs/avalanche-cli";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "avalanche-cli";
  };
}
