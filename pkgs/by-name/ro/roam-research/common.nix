{ fetchurl }:
let
  pname = "roam-research";
<<<<<<< HEAD
  version = "0.0.24";
=======
  version = "0.0.22";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
{
  inherit pname version;
  sources = {
    x86_64-darwin = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/Roam+Research-${version}.dmg";
<<<<<<< HEAD
      hash = "sha256-c7h+ZvR1LtHhOr63xQcRxXC00on2Ob0XfRyS2HU3Qkg=";
    };
    aarch64-darwin = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/Roam+Research-${version}-arm64.dmg";
      hash = "sha256-fPtJAKfh65/dEryi0kdg+1hLfdvzBU87uS0y6eaaVy4=";
    };
    x86_64-linux = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/${pname}_${version}_amd64.deb";
      hash = "sha256-vpceynkr0/IOSqdmtVxKliSIJEGvLhczqgrsQyqPVIo=";
=======
      hash = "sha256-GA9m4z+3Dy87Dz/YPG5MYbREQ1cEAdX/MJvkAJ/fe34=";
    };
    aarch64-darwin = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/Roam+Research-${version}-arm64.dmg";
      hash = "sha256-+lgV5TpTzN7mJvvVEpBbmq+aBOBKy1CpYkMNhfoxhK0=";
    };
    x86_64-linux = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/${pname}_${version}_amd64.deb";
      hash = "sha256-HVGytdP5fkQQABeL9y869GZioutvnBHrwPprAjfBbFg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };
}
