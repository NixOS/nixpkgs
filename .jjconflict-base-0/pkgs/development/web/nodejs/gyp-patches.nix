{ fetchpatch2 }:
let
  name = "gyp-darwin-sandbox.patch";
  url = "https://github.com/nodejs/gyp-next/commit/706d04aba5bd18f311dc56f84720e99f64c73466.patch";
in
[
  # Fixes builds with Nix sandbox on Darwin for gyp.
  # See https://github.com/NixOS/nixpkgs/issues/261820
  # and https://github.com/nodejs/gyp-next/pull/216
  (fetchpatch2 {
    inherit name url;
    hash = "sha256-l8FzgLq9CbVJCkXfnTyDQ+vXKCz65wpaffE74oSU+kY=";
    stripLen = 1;
    extraPrefix = "tools/gyp/";
  })
  (fetchpatch2 {
    inherit name url;
    hash = "sha256-UVUn4onXfJgFoAdApLAbliiBgM9rxDdIo53WjFryoBI=";
    stripLen = 1;
    extraPrefix = "deps/npm/node_modules/node-gyp/gyp/";
  })
]
