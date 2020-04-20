{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glow";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    sha256 = "0vhl8d7xxqqyl916nh8sgm1xdaf7xlc3r18464bd2av22q9yz68n";
  };

  modSha256 = "0r0yq7kgz7i1wf4gxxihdrn1c8mi4wcyhadncxbln24s9c5apxsf";

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Render markdown on the CLI";
    homepage = "https://github.com/charmbracelet/glow";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry filalex77 ];
  };
}
