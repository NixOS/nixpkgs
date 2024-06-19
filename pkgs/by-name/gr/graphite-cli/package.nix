{ lib
, buildNpmPackage
, fetchurl
, git
, installShellFiles
}:

buildNpmPackage rec {
  pname = "graphite-cli";
  version = "1.3.6";

  src = fetchurl {
    url = "https://registry.npmjs.org/@withgraphite/graphite-cli/-/graphite-cli-${version}.tgz";
    hash = "sha256-rD/YWFRHzoM9Gsd9tnCF56RChckaeWGFphYgHa0UvUU=";
  };

  npmDepsHash = "sha256-WyV0f5thWG7hg7Vm1UUIlcFCgP83HfXQFBUVHcQdjRo=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  nativeBuildInputs = [
    git
    installShellFiles
  ];

  dontNpmBuild = true;

  postInstall = ''
    installShellCompletion --cmd gt \
      --bash <($out/bin/gt completion) \
      --fish <(GT_PAGER= $out/bin/gt fish) \
      --zsh <(ZSH_NAME=zsh $out/bin/gt completion)
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "CLI that makes creating stacked git changes fast & intuitive";
    downloadPage = "https://www.npmjs.com/package/@withgraphite/graphite-cli";
    homepage = "https://graphite.dev/docs/graphite-cli";
    license = lib.licenses.unfree; # no license specified
    mainProgram = "gt";
    maintainers = with lib.maintainers; [ diegs ];
  };
}
