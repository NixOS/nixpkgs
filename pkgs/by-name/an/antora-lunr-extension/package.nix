{
  buildNpmPackage,
  fetchFromGitLab,
  fetchurl,
  gitMinimal,
  lib,
  yq,
}:

buildNpmPackage rec {
  pname = "antora-lunr-extension";
  version = "1.0.0-alpha.8";

  src = fetchFromGitLab {
    owner = "antora";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GplCwhUl8jurD4FfO6/T3Vo1WFjg+rtAjWeIh35unk4=";
  };

  npmDepsHash = "sha256-EtjZL6U/uSGSYSqtuatCkdWP0NHxRuht13D9OaM4x00=";

  # Ensure tests pass.
  postPatch =
    let
      path = {
        git = lib.getExe gitMinimal;
        yq = lib.getExe yq;
      };

      uiBundle = fetchurl {
        hash = "sha256-7zcPsAsK/k43sJo5VZrekvKVNOpd8aMUwb9qMdG1cnE=";
        name = "ui-bundle.zip";
        url = "https://gitlab.com/antora/antora-ui-default/-/jobs/7377097942/artifacts/raw/build/ui-bundle.zip";
      };
    in
    ''
      # > In order to use a local content repository with Antora, even when
      # > using the worktree (HEAD), the repository must have at least one
      # > commit.
      # >
      # > -- https://docs.antora.org/antora/3.1/playbook/content-source-url
      ${path.git} init &&
        ${path.git} \
        -c user.email="" \
        -c user.name="name" \
        commit \
        --allow-empty \
        --allow-empty-message \
        --message ""

      # Override UI bundle URL with a Nix store path to prevent tests from
      # fetching the latest version.
      find \
        test \
        -type f \
        -name "*.yml" \
        -exec \
          ${path.yq} \
          --in-place \
          --yaml-output \
          '.ui.bundle.url = "${uiBundle}"' \
          {} +
    '';

  # Pointing $out to $out/lib/node_modules/@antora/lunr-extension simplifies
  # Antora's extension option from
  #
  #     --extension ${pkgs.antora-lunr-extension}/lib/node_modules/@antora/lunr-extension
  #
  # to
  #
  #     --extension ${pkgs.antora-lunr-extension}
  postInstall = ''
    directory="$(mktemp --directory)"

    mv "$out/"{.,}* "$directory"
    mv "$directory/lib/node_modules/@antora/lunr-extension/"{.,}* "$out"
  '';

  meta = {
    description = "Antora extension adding offline, full-text search powered by Lunr";
    homepage = "https://gitlab.com/antora/antora-lunr-extension";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.naho ];
  };
}
