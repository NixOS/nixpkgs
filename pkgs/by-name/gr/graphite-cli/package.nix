{
  lib,
  stdenv,
  buildNpmPackage,
  fetchurl,
  git,
  installShellFiles,
}:

buildNpmPackage rec {
  pname = "graphite-cli";
  version = "1.7.18";

  src = fetchurl {
    url = "https://registry.npmjs.org/@withgraphite/graphite-cli/-/graphite-cli-${version}.tgz";
    hash = "sha256-IDj1hahbggDZTxOpy+UsCuqmIDFZ0Ud8IjYxhlp1zl8=";
  };

  npmDepsHash = "sha256-6VYynLO3fH8B5MKcf7it/BGXBb7pLTD4NngjdzhJLso=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  nativeBuildInputs = [
    git
    installShellFiles
  ];

  dontNpmBuild = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gt \
      --bash <($out/bin/gt completion) \
      --fish <(GT_PAGER= $out/bin/gt fish) \
      --zsh <(ZSH_NAME=zsh $out/bin/gt completion)
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://graphite.dev/docs/cli-changelog";
    description = "CLI that makes creating stacked git changes fast & intuitive";
    downloadPage = "https://www.npmjs.com/package/@withgraphite/graphite-cli";
    homepage = "https://graphite.dev/docs/graphite-cli";
    license = lib.licenses.unfree; # no license specified
    mainProgram = "gt";
    maintainers = with lib.maintainers; [ joshheinrichs-shopify ];
  };
}
