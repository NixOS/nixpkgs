{ lib
, stdenv
, mkYarnPackage
, fetchFromGitHub
, fetchYarnDeps
}:

mkYarnPackage rec {
  pname = "mpris-service";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "dbusjs";
    repo = "mpris-service";
    rev = "v${version}";
    hash = "sha256-pm2+nTtwRvB8OsMnPf4bB9c8Bnh+W4cBfTNbztPr2qI=";
  };

  yarnLock = ./yarn.lock;
  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    inherit yarnLock;
    hash = "sha256-vu6z+OWI+SmGT+ju19uAPRq0Q+aU/sXTYGdIecN899E=";
  };

  meta = with lib; {
    description = "Node.js implementation for the MPRIS D-Bus Interface Specification to create a mediaplayer service";
    homepage = "https://github.com/dbusjs/mpris-service";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
