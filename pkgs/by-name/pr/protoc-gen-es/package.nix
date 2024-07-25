{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "protoc-gen-es";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protobuf-es";
    rev = "refs/tags/v${version}";
    hash = "sha256-bHl8gqNrTm1+Cnj43RWmrLDUz+G11C4gprEiNOpyOdQ=";

    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-ozkkakfSBycu83gTs8Orhm5Tg8kRSrF/vMJxVnPjhIw=";

  npmWorkspace = "packages/protoc-gen-es";

  preBuild = ''
    npm run --workspace=packages/protobuf build
    npm run --workspace=packages/protoplugin build
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Protobuf plugin for generating ECMAScript code";
    homepage = "https://github.com/bufbuild/protobuf-es";
    changelog = "https://github.com/bufbuild/protobuf-es/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      felschr
      jtszalay
    ];
  };
}
