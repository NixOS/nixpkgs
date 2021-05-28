{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glow";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    sha256 ="0jyl5ln7c2naawmw7bljzrldr96xyb5rbis6y6blmyghr0vx07zb";
  };

  vendorSha256 = "0z3r8fvpy36ybgb18sr0lril1sg8z7s99xv1a6g1v3zdnj3zimav";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Render markdown on the CLI, with pizzazz!";
    homepage = "https://github.com/charmbracelet/glow";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry filalex77 penguwin ];
  };
}
