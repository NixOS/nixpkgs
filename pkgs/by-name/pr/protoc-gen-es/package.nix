{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "protoc-gen-es";
<<<<<<< HEAD
  version = "2.10.2";
=======
  version = "2.10.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protobuf-es";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-6YzxDf8NbBWn3sWqdeQLIUiKQa0DIvBWfigV7hKv+p0=";
=======
    hash = "sha256-Eo6+CjFATJhlEc5xGRS/VwC1RuuJ1Ezb2czon9+qSAI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

<<<<<<< HEAD
  npmDepsHash = "sha256-nS2PFNwZUrHk6onEV2I9O7ZoN/c9bRIQ+D3oXnFd7dU=";
=======
  npmDepsHash = "sha256-YCqxK2wdW29Jfx+sBGz9UcuIqCFglt2bpQ5e2xFZKQ0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
    mainProgram = "protoc-gen-es";
  };
}
