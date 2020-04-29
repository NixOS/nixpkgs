{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lnd";
  version = "0.9.2-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    sha256 = "0gm33z89fiqv231ks2mkpsblskcsijipq8fcmip6m6jy8g06b1gb";
  };

  modSha256 = "1khxplvyaqgaddrx1nna1fw0nb1xz9bmqpxpfifif4f5nmx90gbr";

  subPackages = ["cmd/lncli" "cmd/lnd"];

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 ];
  };
}
