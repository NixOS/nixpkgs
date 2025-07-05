{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
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

  patches = [
    # HACK: I did this because we want to configure the toplevel workspace,
    # without pulling in tree-sitter at buildtime (which isn't possible under
    # Nix anyways)
    ./01-remove-treesitter-cli.patch
    # HACK: I did this because the workspace that is used to build `pkg/server`
    # (toplevel) isn't the same as the workspace we want to package. As of
    # right now I cannot find a workaround as `npmWorkspace` cannot be
    # different for the npmInstallHook from the workspace for npmConfigHook
    ./02-add-bin-out.patch
  ];

  postPatch = ''
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
