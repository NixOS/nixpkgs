{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "protoc-gen-connect-es";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-es";
    rev = "refs/tags/v${version}";
    hash = "sha256-w4Vw/f2rUoLN0WnlTNsUgMLpD8n3w5+bufLH5x89HA8=";
  };

  npmDepsHash = "sha256-gbJdCPP8+VyKvpajgnOKvn4+2Tj+HybiPmq40mjeB18=";

  npmWorkspace = "packages/protoc-gen-connect-es";

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Protobuf plugin for generating Connect-ecompatiblenabled ECMAScript code";
    homepage = "https://github.com/bufbuild/connect-es";
    changelog = "https://github.com/bufbuild/connect-es/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr ];
  };
}
