{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glow";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    sha256 = "016psbm93ni81k87i9gx3cjr59j1fmpq5x8vz0ydabczzdshd1py";
  };

  vendorSha256 = "0gvlbj8b5sqk93ahg4b2krwrmr8ljz7cah77fxaxcd98apap0pw6";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Render markdown on the CLI, with pizzazz!";
    homepage = "https://github.com/charmbracelet/glow";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry filalex77 penguwin ];
  };
}
