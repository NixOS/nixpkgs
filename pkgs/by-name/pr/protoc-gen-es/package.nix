{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "protoc-gen-es";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protobuf-es";
    rev = "refs/tags/v${version}";
    hash = "sha256-zyfuj5SCUmmERzHq6trf3c6h58xkqbNfyBoTZ2969nc=";
  };

  npmDepsHash = "sha256-SZq62r8T04UYSjR2LgBYq5bZPbxbVvAVKc1yHBuTG6I=";

  npmWorkspace = "packages/protoc-gen-es";

  preBuild = ''
    npm run --workspace=packages/protobuf build
    npm run --workspace=packages/protoplugin build
  '';

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  # Upstream package-lock.json is broken. For now it
  # requires running `npm-lockfile-fix` and adding missing
  # dependencies like `@bufbuild/buf-linux-{aarch64,x64}`.
  # passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Protobuf plugin for generating ECMAScript code";
    homepage = "https://github.com/bufbuild/protobuf-es";
    changelog = "https://github.com/bufbuild/protobuf-es/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr ];
  };
}
