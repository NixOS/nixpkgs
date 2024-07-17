{
  lib,
  stdenv,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
}:

mkYarnPackage rec {
  pname = "postlight-parser";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "postlight";
    repo = "parser";
    rev = "v${version}";
    hash = "sha256-k6m95FHeJ+iiWSeY++1zds/bo1RtNXbnv2spaY/M+L0=";
  };

  packageJSON = ./package.json;

  doDist = false;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-Vs8bfkhEbPv33ew//HBeDnpQcyWveByHi1gUsdl2CNI=";
  };

  meta = with lib; {
    changelog = "https://github.com/postlight/parser/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://reader.postlight.com";
    description = "Extracts the bits that humans care about from any URL you give it";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
    mainProgram = "postlight-parser";
  };
}
