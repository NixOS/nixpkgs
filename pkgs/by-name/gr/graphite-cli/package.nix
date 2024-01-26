{ lib
, buildNpmPackage
, fetchurl
, installShellFiles
}:

buildNpmPackage rec {
  pname = "graphite-cli";
  version = "1.0.14";

  src = fetchurl {
    url = "https://registry.npmjs.org/@withgraphite/graphite-cli/-/graphite-cli-${version}.tgz";
    hash = "sha256-m54jBeUAWYMXYl2KVw0GMpb7Y3dFGEtzKIanN4WyZSk=";
  };

  npmDepsHash = "sha256-Nk0Aoyv4eEXZD4B9B/B6mJd/UDy8Kc/sHtQWXrLukSk=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  dontNpmBuild = true;

  postInstall = ''
    installShellCompletion --cmd gt \
      --bash <($out/bin/gt completion) \
      --zsh <(ZSH_NAME=zsh $out/bin/gt completion)
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "CLI that makes creating stacked git changes fast & intuitive";
    downloadPage = "https://www.npmjs.com/package/@withgraphite/graphite-cli";
    homepage = "https://graphite.dev/docs/graphite-cli";
    license = lib.licenses.unfree; # no license specified
    mainProgram = "gt";
    maintainers = with lib.maintainers; [ ];
  };
}
