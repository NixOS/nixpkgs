#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

# --strip-optional-dependencies to get rid of deprecated build deps:
#
# n8n
# -> n8n-nodes-base
#    -> ssh2-sftp-client
#       -> ssh2
#          -> cpu-features
#             -> node-gyp@3.8.0 -> python2
#             -> cmake
cd "$(dirname $(readlink -f $0))"

node2nix \
  --14 \
  --strip-optional-dependencies \
  --node-env node-env.nix \
  --input package.json \
  --output node-packages.nix \
  --composition node-composition.nix
