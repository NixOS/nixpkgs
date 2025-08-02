{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  jq,
  moreutils,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "kulala-ls";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala-ls";
    tag = "v${version}";
    hash = "sha256-We7d6if++n8Y0eouY3I9hbb5iJ+YyaPyFSvu6Ff5U0U=";
  };

  postPatch = ''
    jayqueue() {
      ${lib.getExe jq} "$1" "$2" \
        | ${lib.getExe' moreutils "sponge"} "$2"
    }

    # add binary output
    jayqueue '.bin["kulala-ls"] |= "pkg/server/cli.cjs"' package.json

    # remove unneeded tree-sitter dependency
    for i in "" -graphql; do
      jayqueue \
        'del(.devDependencies["tree-sitter-cli"])' \
        "pkg/tree-sitter$i/package.json"
    done

    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-qitg6+Yp/+iNE5mO7b6wvYgzJalRnSpIckJqqHqqq0U=";
  npmBuildScript = "build:server";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal language server for HTTP syntax";
    homepage = "https://github.com/mistweaverco/kulala-ls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dtomvan ];
    mainProgram = "kulala-ls";
  };
}
