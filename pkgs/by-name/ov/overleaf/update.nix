{ writeScript
, lib
, runtimeShell
, curl
, jq
, gnugrep
, nix-update
, git
, gnused
}:

writeScript "update-overleaf" ''
  #!${runtimeShell}
  PATH=${lib.makeBinPath [ curl jq gnugrep nix-update git gnused ]}

  set -euxo verbose

  tag=$(curl -s "https://hub.docker.com/v2/repositories/sharelatex/sharelatex/tags" | jq -r .results[2].name)
  rev=$(curl -s "https://hub.docker.com/v2/repositories/sharelatex/sharelatex/tags/$tag/images" | jq .[0].layers | grep -Po "MONOREPO_REVISION=\K[a-z0-9]*" -m 1)

  (
    cd ../../../../
    nix-update overleaf --version branch=$rev
  )

  sed -i "s/version = \"[0-9a-z-]*\";/version = \"$tag\";/g" package.nix
''

