{ fetchurl }:
let
  pname = "roam-research";
  version = "0.0.18";
in
{
  inherit pname version;
  sources = {
    x86_64-darwin = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/Roam+Research-${version}.dmg";
      hash = "sha256-jyFNH3qrgrsftExL/b2t8bY3W3fYVz+Gp11AuaIMxbg=";
    };
    aarch64-darwin = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/Roam+Research-${version}-arm64.dmg";
      hash = "sha256-AnyvFCbyUi6tcgxYQAj+zPLl4/kVh9ZeupetRhzH0PU=";
    };
    x86_64-linux = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/${pname}_${version}_amd64.deb";
      hash = "sha256-veDWBFZbODsdaO1UdfuC4w6oGCkeVBe+fqKn5XVHKDQ=";
    };
  };
}
