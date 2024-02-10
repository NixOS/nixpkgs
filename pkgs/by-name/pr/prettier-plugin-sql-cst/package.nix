{ lib
, stdenv
, mkYarnPackage
, fetchFromGitHub
, fetchYarnDeps
}:

mkYarnPackage rec {
  pname = "prettier-plugin-sql-cst";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "nene";
    repo = "prettier-plugin-sql-cst";
    rev = "v${version}";
    hash = "sha256-k6m95FHeJ+iiWSeY++1zds/bo1RtNXbnv2spaY/M+L0="; # TODO: Fix.
  };

  packageJSON = ./package.json;

  doDist = false;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-Vs8bfkhEbPv33ew//HBeDnpQcyWveByHi1gUsdl2CNI="; # TODO: Fix.
  };

  meta = with lib; {
    changelog = "https://github.com/nene/prettier-plugin-sql-cst/releases/tag/${src.rev}";
    homepage = "https://github.com/nene/prettier-plugin-sql-cst";
    description = "Prettier SQL plugin that uses sql-parser-cst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ evolutics ];
  };
}
