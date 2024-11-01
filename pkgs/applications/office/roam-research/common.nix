{ fetchurl }:
let
  pname = "roam-research";
  version = "0.0.22";
in
{
  inherit pname version;
  sources = {
    x86_64-darwin = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/Roam+Research-${version}.dmg";
      hash = "sha256-GA9m4z+3Dy87Dz/YPG5MYbREQ1cEAdX/MJvkAJ/fe34=";
    };
    aarch64-darwin = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/Roam+Research-${version}-arm64.dmg";
      hash = "sha256-+lgV5TpTzN7mJvvVEpBbmq+aBOBKy1CpYkMNhfoxhK0=";
    };
    x86_64-linux = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/${pname}_${version}_amd64.deb";
      hash = "sha256-HVGytdP5fkQQABeL9y869GZioutvnBHrwPprAjfBbFg=";
    };
  };
}
