{
  lib,
  stdenv,
  buildNpmPackage,
  fetchurl,
  git,
  makeBinaryWrapper,
  installShellFiles,
}:

buildNpmPackage rec {
  pname = "graphite-cli";
  version = "1.7.5";

  src = fetchurl {
    url = "https://registry.npmjs.org/@withgraphite/graphite-cli/-/graphite-cli-${version}.tgz";
    hash = "sha256-P9hqSriOe+UHF9tjJMiX2X0M7WGG5A+ZLYo3emvdP9Q=";
  };

  npmDepsHash = "sha256-HXdJAKfIMq4iclIxQHLHVOyHkab7j+7R+NayWKDw6S0=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  nativeBuildInputs = [
    git
    makeBinaryWrapper
    installShellFiles
  ];

  dontNpmBuild = true;

  postInstall = ''
    wrapProgram $out/bin/gt \
      --set GRAPHITE_DISABLE_UPGRADE_PROMPT 1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
