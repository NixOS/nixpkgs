{
  antora,
  antora-lunr-extension,
  antora-lunr-extension-test ? false,
  antora-ui-default,
  gitMinimal,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  name = "${antora.pname}${lib.optionalString antora-lunr-extension-test "-${antora-lunr-extension.pname}"}-test";
  src = ./minimal_working_example;

  postPatch =
    let
      date = lib.escapeShellArg "1/1/1970 00:00:00 +0000";
    in
    ''
      # > In order to use a local content repository with Antora, even when using
      # > the worktree (HEAD), the repository must have at least one commit.
      # >
      # > -- https://docs.antora.org/antora/3.1/playbook/content-source-url
      git init &&
        GIT_AUTHOR_DATE=${date} \
        GIT_AUTHOR_EMAIL= \
        GIT_AUTHOR_NAME=Nixpkgs \
        GIT_COMMITTER_DATE=${date} \
        GIT_COMMITTER_EMAIL= \
        GIT_COMMITTER_NAME=Nixpkgs \
        git commit --allow-empty --allow-empty-message --message ""
    '';

  buildPhase =
    let
      playbook = builtins.toFile "antora-playbook.json" (
        builtins.toJSON {
          content.sources = [ { url = "~+"; } ];
          runtime.log.failure_level = "warn";
        }
      );
    in
    ''
      # The --to-dir and --ui-bundle-url options are not included in the
      # playbook due to Antora and Nix limitations.
      antora ${
        lib.cli.toGNUCommandLineShell { } {
          cache-dir = "$(mktemp --directory)";
          extension = if antora-lunr-extension-test then antora-lunr-extension else false;
          to-dir = placeholder "out";
          ui-bundle-url = "${antora-ui-default}/ui-bundle.zip";
        }
      } "${playbook}"
    '';

  nativeBuildInputs = [
    antora
    gitMinimal
  ];

  meta = {
    description = "Reproducible Antora test framework";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.naho ];
    platforms = lib.platforms.all;
  };
}
