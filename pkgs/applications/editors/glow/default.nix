{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glow";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    sha256 = "05scgdivb0hf0lfznikn20b6pgb479jhs24hgf5f5i60v37v930y";
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
