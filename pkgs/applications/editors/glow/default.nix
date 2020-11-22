{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glow";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    sha256 = "0gwzf2p67s0nsb7my5njcz4znlfl62s9gg7x9ywbk9jzsr9avkhv";
  };

  vendorSha256 = "1p50qr7hbc8vyifa23z7xr43b4fpmwdzg7hqs503c124kpbpk45z";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Render markdown on the CLI, with pizzazz!";
    homepage = "https://github.com/charmbracelet/glow";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry Br1ght0ne penguwin ];
  };
}
