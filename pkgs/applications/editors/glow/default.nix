{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glow";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    sha256 = "0cgi7rz5al5smjsna9p2v5zxjn3lwpnhd38vpr1qhz8n0z37vss5";
  };

  vendorSha256 = "180g6d9w3lfmxj4843kqvq4ikg8lwmwprgfxdgz1lzvjmbfjj3g9";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Render markdown on the CLI, with pizzazz!";
    homepage = "https://github.com/charmbracelet/glow";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry filalex77 penguwin ];
  };
}
