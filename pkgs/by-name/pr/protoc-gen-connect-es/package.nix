{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "protoc-gen-connect-es";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-es";
    rev = "refs/tags/v${version}";
    hash = "sha256-pur1OJuud2ZwPAfd6pSuTAx2vtW6kQM9rntDmtvVj3c=";

    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-wObMmeFCP/zZ6P5cCVkFnn5X0h9/4ePsSj9uBd6C1/Y=";

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
