{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "protoc-gen-connect-es";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-es";
    rev = "refs/tags/v${version}";
    hash = "sha256-qCIwr4Hyc5PARUa7tMntuyWRmO6ognmtjxN0myo8FXc=";

    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-OGwEpXZqzMSIES+cmseQlo6/vzkx5ztO0gM/rUB0tGY=";

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
