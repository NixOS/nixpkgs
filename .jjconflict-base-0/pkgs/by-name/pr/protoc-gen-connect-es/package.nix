{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "protoc-gen-connect-es";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-es";
    rev = "refs/tags/v${version}";
    hash = "sha256-cB1OTolnwHOqeXrj8wL5FbFnjok6s03z1jC58ABTW3o=";

    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-VkvWHKERJwG7MVZ5Pb7ufRCBBWkcoMCoabtMETcPvrU=";

  npmWorkspace = "packages/protoc-gen-connect-es";

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Protobuf plugin for generating Connect-ecompatiblenabled ECMAScript code";
    homepage = "https://github.com/connectrpc/connect-es";
    changelog = "https://github.com/connectrpc/connect-es/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      felschr
      jtszalay
    ];
  };
}
