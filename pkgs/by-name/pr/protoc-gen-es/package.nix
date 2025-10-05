{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "protoc-gen-es";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protobuf-es";
    tag = "v${version}";
    hash = "sha256-Tt6jD2zbGc7strNe9knzh7RMR9AVmDNeigIOfH1Wod8=";

    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-UntjjAO2W2rraqkglu5kzfMFk1nKFDJN0x6WNxx1X6E=";

  npmWorkspace = "packages/protoc-gen-es";

  preBuild = ''
    npm run --workspace=packages/protobuf build
    npm run --workspace=packages/protoplugin build
  '';

  # copy npm workspace modules while properly resolving symlinks
  # TODO: workaround can be removed once this is merged: https://github.com/NixOS/nixpkgs/pull/333759
  postInstall = ''
    rm -rf $out/lib/node_modules/protobuf-es/node_modules/ts4.*
    cp -rL node_modules/ts4.* $out/lib/node_modules/protobuf-es/node_modules/

    rm -rf $out/lib/node_modules/protobuf-es/node_modules/ts5.*
    cp -rL node_modules/ts5.* $out/lib/node_modules/protobuf-es/node_modules/

    rm -rf $out/lib/node_modules/protobuf-es/node_modules/upstream-protobuf
    cp -rL node_modules/upstream-protobuf $out/lib/node_modules/protobuf-es/node_modules/

    rm -rf $out/lib/node_modules/protobuf-es/node_modules/@bufbuild
    cp -rL node_modules/@bufbuild $out/lib/node_modules/protobuf-es/node_modules/
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Protobuf plugin for generating ECMAScript code";
    homepage = "https://github.com/bufbuild/protobuf-es";
    changelog = "https://github.com/bufbuild/protobuf-es/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      felschr
      jtszalay
    ];
  };
}
