{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gh-token";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "Link-";
    repo = "gh-token";
    rev = "v${version}";
    hash = "sha256-ufpQQgXaL28lPPLotZZneJPWWAy80Jd6hNeKX81aa98=";
  };

  vendorHash = "sha256-gUPNHSeI8B5hwnIo7gwGo5aP4j7rzgveZIksyNe65jM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Manage installation access tokens for GitHub apps from your terminal";
    homepage = "https://github.com/Link-/gh-token";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ norbertwnuk ];
    mainProgram = "gh-token";
  };
}
