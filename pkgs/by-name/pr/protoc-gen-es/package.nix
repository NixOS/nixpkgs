{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "protoc-gen-es";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protobuf-es";
    rev = "refs/tags/v${version}";
    hash = "sha256-yeGPtSfxq9bNhWgLEbt6lT7B1CNEgJS0E9hxwHa/Lfw=";

    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-2PcpDF5ohPu92TkMjg2NyXAvPt+yZuAtLHYkGuE7TRo=";

  npmWorkspace = "packages/protoc-gen-es";

  preBuild = ''
    npm run --workspace=packages/protobuf build
    npm run --workspace=packages/protoplugin build
  '';

  # copy npm workspace modules while properly resolving symlinks
  # TODO: workaround can be removed once this is merged: https://github.com/NixOS/nixpkgs/pull/333759
  postInstall = ''
    rm -rf $out/lib/node_modules/protobuf-es/node_modules/@bufbuild
    cp -rL node_modules/@bufbuild $out/lib/node_modules/protobuf-es/node_modules/
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
